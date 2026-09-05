#!/home/alex/.local/share/simpleicon-venv/bin/python
"""Download a Simple Icons brand-colour SVG and render it as PNG.

Usage:
    simpleicon.py github
    simpleicon.py github --size 1024

The icon name is the Simple Icons slug, e.g. ``github`` or ``python``.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

OUTPUT_DIR = Path("/mnt/d/multimedia/images/icons")
CDN_URL = "https://cdn.simpleicons.org/{slug}"
SLUG_RE = re.compile(r"^[a-z0-9][a-z0-9-]*$")


def download_svg(slug: str) -> bytes:
    request = Request(
        CDN_URL.format(slug=slug),
        headers={"User-Agent": "simpleicon.py/1.0"},
    )
    try:
        with urlopen(request, timeout=30) as response:
            svg = response.read()
    except HTTPError as error:
        if error.code == 404:
            raise RuntimeError(f"Simple Icons has no icon named {slug!r}") from error
        raise RuntimeError(f"Simple Icons request failed with HTTP {error.code}") from error
    except URLError as error:
        raise RuntimeError(f"Could not reach Simple Icons: {error.reason}") from error

    if not svg.lstrip().startswith(b"<svg"):
        raise RuntimeError("Simple Icons returned something other than an SVG")
    if b'fill="' not in svg:
        raise RuntimeError("The downloaded SVG does not contain a brand colour")
    return svg


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("slug", help="Simple Icons slug, such as github or python")
    parser.add_argument(
        "--size",
        type=int,
        default=512,
        help="PNG width and height in pixels (default: 512)",
    )
    args = parser.parse_args()

    if not SLUG_RE.fullmatch(args.slug):
        parser.error("slug must contain only lowercase letters, numbers, and hyphens")
    if args.size < 1:
        parser.error("--size must be a positive integer")

    try:
        import cairosvg
    except ImportError:
        print(
            "PNG rendering requires CairoSVG. Install it with: python3 -m pip install --user cairosvg",
            file=sys.stderr,
        )
        return 1

    try:
        svg = download_svg(args.slug)
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        svg_path = OUTPUT_DIR / f"{args.slug}.svg"
        png_path = OUTPUT_DIR / f"{args.slug}.png"
        cairosvg.svg2png(bytestring=svg, write_to=str(png_path), output_width=args.size, output_height=args.size)
        svg_path.write_bytes(svg)
    except (OSError, RuntimeError) as error:
        print(f"simpleicon: {error}", file=sys.stderr)
        return 1

    print(f"Saved {svg_path}")
    print(f"Saved {png_path} ({args.size}x{args.size})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
