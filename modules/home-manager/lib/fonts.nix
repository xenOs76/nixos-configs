{lib, ...}: {
  ptToPx = pt: lib.max 1 (lib.floor (pt * 96 / 72 + 0.5));
}
