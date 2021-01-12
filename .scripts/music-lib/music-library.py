import collections
import glob
import re
import os
import ntpath
import posixpath
import sys
import warnings

import parse


Item = collections.namedtuple('Release', 'path, format, artist, release')


class Collection(object):

    def __init__(self, annex_path):
        self.annex_path = os.path.abspath(os.path.expanduser(annex_path))

    @property
    def _annex_structure(self):
        # Derived from the Item definition
        return os.path.join(*(
            '{{{}}}'.format(f)
            for f in Item._fields
            if f != 'path'
        ))

    @property
    def _glob_pattern(self):
        # The structure is relative to the annex path
        relative_pattern = ['*']*len(self._annex_structure.split('/'))
        return os.path.join(
            self.annex_path,
            *relative_pattern
        )

    def inspect(self):
        root = self.annex_path
        paths = [os.path.relpath(p, start=root) for p in glob.glob(self._glob_pattern)]
        items = [Item(path=os.path.join(root, p), **parse.parse(self._annex_structure, p).named) for p in paths]
        releases = collections.defaultdict(dict)
        for item in items:
            releases[(item.artist, item.release)][item.format] = item
        return releases


class Library(object):

    _default_formats = ('flac', 'ogg', 'mp3', 'mp4', 'wma')
    _library_structure = '{artist}/{release}'

    def __init__(self, host_os=None, requested_formats=None):
        self.releases = []
        self.host_os = host_os if host_os else 'wsl'
        self._formats = requested_formats if requested_formats else self._default_formats

    @property
    def path_sep(self):
        return {
            'wsl': posixpath.sep,
            'win': ntpath.sep,
        }[self.host_os]

    @property
    def library_structure(self):
        field_set = set(re.findall(r'{([^}]+)}', self._library_structure))
        valid_fields = set(Item._fields).difference(['path'])
        if not field_set.issubset(valid_fields):
            diff = field_set.difference(valid_fields)
            raise Exception(f"Library structure contains unrecognised fields: {diff}")
        return self.path_sep.join(['{root}', *self._library_structure.split('/')])

    def reduce_collection(self, collection):
        """Flatten a multi-format collection based on preferred formats.

        Reduces a collection to a single format of each item, with the format
        picked based on the library's supported formats.
        """
        self.collection = collection
        releases = self.releases = set([])
        for key, instances in collection.inspect().items():
            valid_format = False
            for fmt in self._formats:
                try:
                    releases.add(instances[fmt])
                    valid_format = True
                    break
                except KeyError:
                    continue
            if not valid_format:
                available_formats = set(instances.keys())
                warnings.warn(f"{key} not available in suitable format, only {available_formats}", UserWarning)
        return releases

    def generate_ps_statements(self, root_directory):
        annex_path = self.collection.annex_path
        root = os.path.abspath(os.path.expanduser(root_directory))
        structure = self.library_structure
        if not self.releases:
            warnings.warn("No releases defined, nothing to create. Call .reduce_collection(...) first")
        common_prefix = os.path.commonprefix([root, annex_path])
        if len(common_prefix.split(os.path.sep)) < 2:
            warnings.warn("Relative paths are used for links, library must share a mountpoint with the annex")
        else:
            relative_root = os.path.relpath(root, annex_path)
            def ps_escape(string_literal):
                return f"[Management.Automation.WildcardPattern]::Escape({string_literal})"

            def derive_literal_path(item):
                return structure.format(root=relative_root, **item._asdict())
            statements = []
            for item in self.releases:
                link_path = derive_literal_path(item)
                #ps_link_path = ps_escape(f"'{link_path}'")
                ps_link_path = f'"{link_path}"'
                ps_target_path = ps_escape(ps_escape(f'"{os.path.relpath(item.path, annex_path)}"'))
                mkdirs = f'$null = New-Item -Type Directory -Force "{os.path.dirname(link_path)}"'
                set_link_path = f"$link = {ps_link_path}"
                set_target_path = f"$target = {ps_target_path}"
                create_symlink = ' '.join([
                    'New-Item',
                    '-ItemType',
                    'SymbolicLink',
                    '-Path',
                    '$link',
                    '-Target',
                    '$target'
                ])
                statements.extend([mkdirs, set_link_path, set_target_path, create_symlink, ''])
            return statements


if __name__ == '__main__':
    collection = Collection(sys.argv[1])
    library = Library()
    #print(library.reduce_collection(collection))
    library.reduce_collection(collection)
    print('\n'.join(library.generate_ps_statements('/mnt/d/multimedia/audio/music/Music')))