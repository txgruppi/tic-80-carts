class TitleScreen {
  static TIC() {
    var darkBrown = 1
    var lightBlue = 11
    var darkGray = 15
    var green = 10

    // wall
    TIC.rect(198, 0, 42, 136, darkGray)

    // long floor
    TIC.tri(-16, -19, 110, 137, 240, 136, darkBrown)

    // short floor
    TIC.tri(126, 135, 240, 97, 240, 136, darkBrown)

    TIC.spr(Sprites.titleChar01, 66, 6, lightBlue, 1, 0, 0, 2, 7)
    TIC.spr(Sprites.titleChar02, 138, 58, green, 1, 0, 0, 8, 10)
  }
}
