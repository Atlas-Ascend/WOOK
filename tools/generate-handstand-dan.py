#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import argparse

# WOOK four-shade monochrome source palette. Transparent remains alpha=0.
INK = (15, 33, 35, 255)
DARK = (49, 83, 75, 255)
MID = (127, 160, 111, 255)
LIGHT = (196, 217, 154, 255)
CLEAR = (0, 0, 0, 0)


def px(im, x, y, c):
    if 0 <= x < 16 and 0 <= y < 16:
        im.putpixel((x, y), c)


def block(im, x0, y0, x1, y1, c):
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            px(im, x, y, c)


def outline_human(frame, variant=0, handstand=False):
    im = Image.new('RGBA', (16, 16), CLEAR)
    if handstand:
        # hands / contact
        px(im, 5, 14, INK); px(im, 10, 14, INK)
        px(im, 4, 13, DARK); px(im, 11, 13, DARK)
        # long arms
        px(im, 5, 12, DARK); px(im, 10, 12, DARK)
        px(im, 6, 11, MID); px(im, 9, 11, MID)
        px(im, 6, 10, DARK); px(im, 9, 10, DARK)
        # head + hair/headband
        block(im, 6, 7, 9, 9, MID)
        block(im, 6, 7, 9, 7, INK)
        px(im, 5, 8, DARK); px(im, 10, 8, DARK)
        px(im, 7, 8, INK); px(im, 8, 8, INK)
        # torso inverted
        block(im, 6, 4, 9, 6, DARK)
        block(im, 7, 4, 8, 5, LIGHT)
        # hips / shorts
        block(im, 6, 2, 9, 3, INK)
        # legs upward, with wobble variants
        if variant % 3 == 0:
            px(im, 6, 1, DARK); px(im, 5, 0, MID)
            px(im, 9, 1, DARK); px(im, 10, 0, MID)
        elif variant % 3 == 1:
            px(im, 6, 1, DARK); px(im, 6, 0, MID)
            px(im, 9, 1, DARK); px(im, 9, 0, MID)
        else:
            px(im, 6, 1, DARK); px(im, 7, 0, MID)
            px(im, 9, 1, DARK); px(im, 8, 0, MID)
    else:
        # head/hair/headband
        block(im, 6, 2, 9, 5, MID)
        block(im, 5, 2, 10, 2, INK)
        px(im, 5, 3, DARK); px(im, 10, 3, DARK)
        px(im, 7, 4, INK); px(im, 8, 4, INK)
        # torso, sleeveless-ish
        block(im, 6, 6, 9, 10, DARK)
        block(im, 7, 6, 8, 9, LIGHT)
        # long arms and wrist wraps
        arm_shift = 1 if variant % 2 else 0
        px(im, 5, 7 + arm_shift, MID); px(im, 10, 7 + (1-arm_shift), MID)
        px(im, 4, 8 + arm_shift, DARK); px(im, 11, 8 + (1-arm_shift), DARK)
        px(im, 4, 9 + arm_shift, INK); px(im, 11, 9 + (1-arm_shift), INK)
        # shorts / legs
        block(im, 6, 11, 9, 12, INK)
        if variant % 2 == 0:
            px(im, 6, 13, DARK); px(im, 5, 14, INK)
            px(im, 9, 13, DARK); px(im, 10, 14, INK)
        else:
            px(im, 6, 13, DARK); px(im, 6, 14, INK)
            px(im, 9, 13, DARK); px(im, 9, 14, INK)
        # contact shadow
        block(im, 5, 15, 10, 15, DARK)
    return im


def make_sheet(path: Path):
    out = Image.new('RGBA', (96, 16), CLEAR)
    frames = [
        outline_human(0, 0, False),
        outline_human(1, 1, False),
        outline_human(2, 2, False),
        outline_human(3, 0, True),
        outline_human(4, 1, True),
        outline_human(5, 2, True),
    ]
    for i, fr in enumerate(frames):
        out.alpha_composite(fr, (i * 16, 0))
    path.parent.mkdir(parents=True, exist_ok=True)
    out.save(path)


def make_avatar(path: Path):
    im = Image.new('RGBA', (16, 16), CLEAR)
    # larger face/headband portrait with strong asymmetry and long-hair cues
    block(im, 3, 2, 12, 3, INK)
    block(im, 4, 4, 11, 10, MID)
    px(im, 3, 5, DARK); px(im, 12, 5, DARK)
    px(im, 3, 6, DARK); px(im, 12, 6, DARK)
    block(im, 5, 5, 6, 6, INK); block(im, 9, 5, 10, 6, INK)
    px(im, 7, 8, DARK); px(im, 8, 8, DARK)
    block(im, 6, 10, 9, 10, INK)
    block(im, 4, 11, 11, 13, DARK)
    px(im, 2, 7, INK); px(im, 13, 7, INK)
    path.parent.mkdir(parents=True, exist_ok=True)
    im.save(path)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--sprite', required=True)
    p.add_argument('--avatar', required=True)
    args = p.parse_args()
    make_sheet(Path(args.sprite))
    make_avatar(Path(args.avatar))
    print('HANDSTAND_DAN_SOURCE_GENERATION=PASS')


if __name__ == '__main__':
    main()
