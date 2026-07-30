#!/usr/bin/env python3
"""Compose deterministic App Store artwork from real simulator captures."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "store_assets" / "appstore" / "raw"
OUTPUT_DIR = ROOT / "store_assets" / "appstore" / "final"
LOGO_PATH = ROOT / "assets" / "images" / "app_logo.png"

CANVAS_SIZE = (1242, 2688)
SCREEN_WIDTH = 900
SCREEN_TOP = 665
SCREEN_CORNER_RADIUS = 64

FONT_BOLD = "/Library/Fonts/SF-Pro-Display-Bold.otf"
FONT_SEMIBOLD = "/Library/Fonts/SF-Pro-Display-Semibold.otf"
FONT_REGULAR = "/Library/Fonts/SF-Pro-Display-Regular.otf"

ARTWORK = (
    {
        "source": "qr-preview.png",
        "output": "01-create-and-share.png",
        "eyebrow": "CREATE",
        "headline": "Create codes\nin seconds",
        "subtitle": "Generate crisp QR codes, then save or share instantly.",
        "accent": (77, 119, 255),
    },
    {
        "source": "library.png",
        "output": "02-organized-library.png",
        "eyebrow": "ORGANIZE",
        "headline": "Everything,\nright where you need it",
        "subtitle": "Search and filter every code stored on your device.",
        "accent": (99, 102, 241),
    },
    {
        "source": "barcode-preview.png",
        "output": "03-qr-and-barcodes.png",
        "eyebrow": "VERSATILE",
        "headline": "QR codes and\nbarcodes, together",
        "subtitle": "Reliable white-canvas previews stay ready to scan.",
        "accent": (45, 212, 191),
    },
)


def _font(path: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(path, size)


def _vertical_gradient(accent: tuple[int, int, int]) -> Image.Image:
    width, height = CANVAS_SIZE
    image = Image.new("RGB", CANVAS_SIZE)
    pixels = image.load()
    top = (8, 15, 32)
    bottom = (12, 28, 61)

    for y in range(height):
        progress = y / (height - 1)
        eased = progress * progress
        row = tuple(
            round(top[channel] * (1 - eased) + bottom[channel] * eased)
            for channel in range(3)
        )
        for x in range(width):
            pixels[x, y] = row

    glow = Image.new("RGBA", CANVAS_SIZE, (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    glow_draw.ellipse(
        (-260, -380, 760, 680),
        fill=(*accent, 110),
    )
    glow_draw.ellipse(
        (710, 260, 1510, 1060),
        fill=(*accent, 55),
    )
    glow = glow.filter(ImageFilter.GaussianBlur(170))
    return Image.alpha_composite(image.convert("RGBA"), glow)


def _add_brand_mark(canvas: Image.Image, accent: tuple[int, int, int]) -> None:
    draw = ImageDraw.Draw(canvas)
    logo = Image.open(LOGO_PATH).convert("RGBA")
    logo.thumbnail((66, 66), Image.Resampling.LANCZOS)

    logo_plate = Image.new("RGBA", (76, 76), (255, 255, 255, 245))
    logo_mask = Image.new("L", logo_plate.size, 0)
    ImageDraw.Draw(logo_mask).rounded_rectangle(
        (0, 0, 75, 75),
        radius=21,
        fill=255,
    )
    logo_plate.putalpha(logo_mask)
    canvas.alpha_composite(logo_plate, (82, 92))
    canvas.alpha_composite(logo, (87, 97))

    draw.text(
        (180, 109),
        "CODE POCKET",
        font=_font(FONT_SEMIBOLD, 34),
        fill=(235, 241, 255, 230),
    )
    draw.rounded_rectangle(
        (82, 197, 204, 205),
        radius=4,
        fill=(*accent, 255),
    )


def _add_copy(
    canvas: Image.Image,
    eyebrow: str,
    headline: str,
    subtitle: str,
    accent: tuple[int, int, int],
) -> None:
    draw = ImageDraw.Draw(canvas)
    draw.text(
        (82, 228),
        eyebrow,
        font=_font(FONT_SEMIBOLD, 28),
        fill=(*accent, 255),
        stroke_width=0,
    )
    draw.multiline_text(
        (82, 276),
        headline,
        font=_font(FONT_BOLD, 92),
        fill=(250, 252, 255, 255),
        spacing=-8,
    )
    draw.text(
        (82, 540),
        subtitle,
        font=_font(FONT_REGULAR, 35),
        fill=(193, 205, 229, 255),
    )


def _add_screenshot(canvas: Image.Image, source_path: Path) -> None:
    screen = Image.open(source_path).convert("RGBA")
    target_height = round(screen.height * SCREEN_WIDTH / screen.width)
    screen = screen.resize((SCREEN_WIDTH, target_height), Image.Resampling.LANCZOS)

    mask = Image.new("L", screen.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, screen.width - 1, screen.height - 1),
        radius=SCREEN_CORNER_RADIUS,
        fill=255,
    )
    screen.putalpha(mask)

    x = (CANVAS_SIZE[0] - screen.width) // 2
    shadow = Image.new("RGBA", CANVAS_SIZE, (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle(
        (
            x - 22,
            SCREEN_TOP + 24,
            x + screen.width + 22,
            SCREEN_TOP + screen.height + 50,
        ),
        radius=SCREEN_CORNER_RADIUS + 20,
        fill=(0, 0, 0, 150),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(35))
    canvas.alpha_composite(shadow)

    border = Image.new(
        "RGBA",
        (screen.width + 8, screen.height + 8),
        (255, 255, 255, 0),
    )
    ImageDraw.Draw(border).rounded_rectangle(
        (0, 0, border.width - 1, border.height - 1),
        radius=SCREEN_CORNER_RADIUS + 4,
        fill=(225, 234, 252, 110),
    )
    canvas.alpha_composite(border, (x - 4, SCREEN_TOP - 4))
    canvas.alpha_composite(screen, (x, SCREEN_TOP))


def compose(item: dict[str, object]) -> Path:
    source = RAW_DIR / str(item["source"])
    output = OUTPUT_DIR / str(item["output"])
    accent = item["accent"]
    assert isinstance(accent, tuple)

    canvas = _vertical_gradient(accent)
    _add_brand_mark(canvas, accent)
    _add_copy(
        canvas,
        str(item["eyebrow"]),
        str(item["headline"]),
        str(item["subtitle"]),
        accent,
    )
    _add_screenshot(canvas, source)
    canvas.convert("RGB").save(output, format="PNG", optimize=True)
    return output


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for item in ARTWORK:
        output = compose(item)
        print(output)


if __name__ == "__main__":
    main()
