SECTION "Memory Utils", ROM0

; Copies the data from `de` into `hl` for `bc` length
CopyDEIntoMemoryAtHL::
    ld a, [de]
    ld [hli], a

    inc de
    dec bc

    ld a, b
    or a, c

    jp nz, CopyDEIntoMemoryAtHL
    ret

; Copies the data from `de`, with a 52 offset, into `hl` for `bc` length
CopyDEIntoMemoryAtHL_W52Offset::
    ld a, [de]
    add a, 52
    ld [hli], a

    inc de
    dec bc

    ld a, b
    or a, c

    jp nz, CopyDEIntoMemoryAtHL_W52Offset
    ret