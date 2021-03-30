// title:  bomberman
// desc:   A bomberman inspired game
// author: txgruppi and xevin
// version: __VERSION__
// script: wren

// TODO
// 1. Add player death animation (20 frames)
// 2. prevent placing a bomb on top of an existing bomb

import "random" for Random
import "./lib/global"
import "./lib/menustate"
import "./lib/playstate"
import "./lib/gameoverstate"

class Game is TIC {
	construct new() {
		_state = MenuState.new()
		Global.resetWins()
	}

	state { _state }
	state=(v) { _state = v }

	TIC() {
		_state.TIC(this)
	}
}

// <TILES>
// 000:1111112112131111111111111111121111111111113111131111111121111111
// 001:eddddddcfeeeeeedfefeefedfeeeeeedfeeeeeedfefeefedfeeeeeedfffffffe
// 002:3444444444444342444444444434443424444444444444444434443444442444
// 003:4444444243444444444424444444424444444444444444443443444444244434
// 004:3444444444dd43424fed44444ff4443424444444444444444424fd342444fe44
// 005:d44444d2e3444eedf44424444444d24444dded444feed44434fef444442f44fe
// 006:34444444444443dd4444fdef443feeee24feeede44feeefe4feedeee4feffeef
// 007:44424443dd444444eedd3444deeed444fdeeed44eeeeed34eefdeed4feeeefd4
// 008:feefded4eeedeed4efeeed44edeeed42eeeed344fedd4444dd34444444444443
// 009:4fdeeeed4feedfee43fefeee44fefefd444feeef4443ffee444444ff34442444
// 010:eeffeeeeefeedeeeefedeeeeeedeeeeefeeeeeefeffeeefeeddeeefeeeeeefde
// 011:eeeefeeeeeeeeffdeeeeeeefedeeeeeefedeeeeefeedefdeeffeefdeeeeefeee
// 012:edeeefdeefeeeefdeeeeeefeeedeeeeeeefdedeeefeddfeefeeeefdefeeeeede
// 014:ccc5ccc577567755c5ccc5cc55775577ccc5ccc577657756c5ccc5cc65775577
// 016:1111112152135515515555511555555115555555155555131115555121511115
// 017:1111112112131111111111111c6c6cc1166666c1176666711111111221111111
// 018:111111211266661116557c611675576116775561116666131111111121111111
// 019:1111112112151111111c11111c161c11656565c1767676731111111121111111
// 020:111111211213111111ccccc116666ccc116666c111366c131111c11121111111
// 021:1ccccccc1766666c1766166c1761116c1766166c117616711117671111117111
// 022:00000000054000000004d00000fecd0000ffed00000ff0000000000000000000
// 023:0540000000f4ed000fee4cd00ffeedd00fefeed00ffefdd000ffff0000000000
// 024:2222222213444432141331421322223214333342131221321444444211111112
// 025:7777777756cccc675c1661c7567777675c6666c7561771675cccccc755555557
// 028:0c0000c0c0cccc0c0c0000c00c0c00c00c00c0c00c0000c0c0cccc0c0c0000c0
// 029:ddddddddfefffffdfd0000fdfd0000fdfd0000fdfd0000fdfdddddedfffffffd
// 030:55515551ff13ff115155515511ff11ff55515551ff31ff135155515521ff11ff
// 031:ddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffff
// 032:00000000004000000904400008aff00000999a00000f08000000030000000000
// 033:00000000000000000024400009aff00008999a00000002000000000000000000
// 034:00000000000000000004400008affa0000999980000000000000000000000000
// 035:000000000000000000044000000ffa8000a99900002000000000000000000000
// 036:000000000000040000044090000ffa8000a999000080f0000030000000000000
// 038:0088000008008000008008000800008008000080008008000008800000000000
// 040:1111112112131111111616111776771111656111113751131111111121111111
// 041:1111112112755111115765711666c751157c6751175676131575517121511111
// 042:115115215275775117766775156cc651576cc651177667735175771525151151
// 043:175175215676676717ccc6757c7c7c675ccccc6177ccc767567c677525757151
// 044:11115121ff1311f115f11ffff771171111f11ff11f3f11f3111f5f11f111111f
// 045:1ee15f21ff1311f115f11f1ff7111111e1f111111f3111f3111f5fe1e1111e11
// 046:ff11f12ff11111f11111111ff1111111f1111111f11111131111111fe111fef1
// 048:00000000000bb00000bbbb0000bbbb0000bbbb0000bbbb000000000000000000
// 049:000b0000000bb000000bb00000bbbb0000bbbb00000bb0000000000000000000
// 050:000bb00000bbbb0000bbbb00000bb000000bb000000b00000000000000000000
// 051:00000000000bb00000bbbb0000bbbb0000bbbb00000bb0000000b00000000000
// 056:05bbbbb0bb3ffbbbbbfde5bb5bfee3fbb3fffdefbfdefeefbfeefffb0bffbbb0
// 057:05000000003ff00000fde50050fee3f003fffdef0fdefeef0feefff000ff0000
// 058:0b7cc7b0bb7cc7bbbb7cc7bbbb6cc6bbb76cc67b76cccc676cccccc606cccc60
// 059:007cc700007cc700007cc700006cc600076cc67076cccc676cccccc606cccc60
// </TILES>

// <SPRITES>
// 000:bbb7bbbbbbbbbb7bbbbbbbb7bbbbbbb6bbbbbbb7bbbbbb0dbbbbb0ffbbbb0fdd
// 001:bbbbbbbbbbbbbbbb6bbbbbbbbbbbbbbbbbbbbbbb00bbbbbbff0bbbbbfff0bbbb
// 002:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 003:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 004:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 005:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 006:aaaaaaa0aaaaa00faaaa0bfbaaa0bfbbaa0bfbbba0bfbbbb0bfbbbbb0fbbbbbb
// 007:00000000fbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 008:00aaaaaabb000aaabbbb00aabbbbb60abbbbbb60bbbbbb60bbbbbb6cbbbbbbb6
// 009:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0aaaaaaa0aaaaaaa
// 010:0000000000000000000000000000000000000006000000060000000000ccc600
// 011:00000006000cccc406c4c64664466c646466c64666466c646664c64644666443
// 012:6666666044332326434332224433232243433222443323224343322244332322
// 013:00000000666000002126600012111600212116601211c660211c66001cc66600
// 014:0000000000000000000000000000000000000000000000000000000006cc0000
// 016:bbbb0fddbb000fffb0440fffb04400ffb0440b00b04440bbb0000bbbb090bbbb
// 017:fff0bbbbfff000bbfff0440bff00440b0004440bbbb0440bbbbb000bbbbb0990
// 018:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 019:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 020:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 021:aaaaaaa0aaaaaaa0aaaaaa00aaaaaa00aaaaaa00aaaaaa00aaaaaa00aaaaaa00
// 022:0bfbbbbb0fbbbbbb00bbbbbb0000bbbb0000c0cc0000c0cc000c0ccc000c0ccc
// 023:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcc000000cc000000c0000000c0000000
// 024:bbbbbbb6bbbbbbb6bbbbbbb6bbbbbbb600bbbbb6000bbbb6000bbbb6000bbbb6
// 025:c0aaaaaac0aaaaaac0aaaaaac0aaaaaac0aaaaaac0aaaaaac0aaaaaac0aaaaaa
// 026:0666666664000024600000026000000060000000600000006000000060000000
// 027:4444666644444466444446464444446644444646044444660444464600444464
// 028:434332cc66666666666666666666666666666666666666666666666666666666
// 029:c66c666666cc666466cc664066cc660066c664006666600066c6400066c60000
// 030:6666c00000006c00000006000000060000000600000006000000060000000600
// 032:0990bb000aa0b099099009990990900d0990900db099000db0990999b0999099
// 033:00bb0990990b0aa09990099000000990000099900000990b9990990b9990990b
// 034:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 035:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 036:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 037:aaaaaa00aaaaaa00aaaaaa0baaaaaa0faaaaaa0baaaaaaa0aaaaa000aaa00bb0
// 038:00c0cccc00c0cccc0c0cccc0bc0cccc0fbcccc00bfbbcc00fbbbbbbbbfbbbbbb
// 039:000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
// 040:000bbbb6000bbbb6000bbbbc00bbbb6000bbbb60bbbbb60abbbbb0aabbb000aa
// 041:c0aaaaaac0aaaaaa0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 042:4000000006000000040000000046666600000000000000000000000000000000
// 043:0044444600244464002444466666444622224444000002460000002400000002
// 044:6666666666666666666666664666666666666666466666666666666644666660
// 045:6c66000066660000666600006666666666644400600000000000000000000000
// 046:0000040000006000000040006664000000000000000000000000000000000000
// 048:bb099900bb09999abbb0999abbb0999abbbb099abbbb099abbbb099abbbbb09a
// 049:000990bb9a9990bb9a990bbb9a990bbb9a90bbbb9a90bbbb9a90bbbb9a0bbbbb
// 050:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 051:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 052:aaaaaaaaaaaaaaaaaaaaaaa0aaaaaa0baaaaa0bcaaaaa0bcaaaa0bcbaaaa0bcb
// 053:a00bbccc0bbccbbbbccbbbbbcbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 054:0bbbbbbbb000bbbbbbbb0000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 055:bbbbbbbbbbbbbb00000000bbbbbb00bbbbbbb0bbbbbb00bbbbbb0bbbbbbb00bb
// 056:000ccc0abb6666c0bbbbb66cbbbbbb66bbbbbbb6bbbbbbb6bbbbbbb6bbbbbb6c
// 057:aaaaaaaaaaaaaaaa0aaaaaaac0aaaaaac0aaaaaac0aaaaaac0aaaaaa0aaaaaaa
// 060:24666600046660000466c000046660000466c00004666000466666004666c600
// 064:bbbbb000bbbbb000bbbb0999bbbb0999bbbb0999bbbb0999bbb09990bbb09990
// 065:000bbbbb000bbbbb9990bbbb9990bbbb99990bbb09990bbbb0990bbbb09990bb
// 066:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 067:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 068:aaaa0bcbaaaa0bcbaaaa0bcbaaaa0bcbaaaa0bcbaaaa0bcbaaaa0bcbaaaa0bcb
// 069:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbb8bbbbbbb8bbbbbbb8
// 070:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 071:bbbbb0bbbbbb00bbbbbb0bb2bbbb2224bbb24424bbb24244bb824444b8244444
// 072:bbbbbb6cbbbbb6c02bbbb60a62bb6c0a462b60aa462b60aa446260aa44620aaa
// 073:0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 074:0000000000000000000000000000000000000003000000330000033300000333
// 075:0000000400333346033334663333466633333666333333363333333333333333
// 076:6666cc606666ccc666666ccc66666ccc66666cc6666666633333333333333333
// 077:000000003333000063333000c633330063333330333333333333333333333333
// 078:0000000000000000000000000000000000000000000000003000000030000000
// 080:bbb0990bbbb0990bbb09990bbb09990bbb0990bbbb0990bbbb0aa0bbbb0990bb
// 081:bb0990bbbb09990bbbb0990bbbb0990bbbb0990bbbb0990bbbb0aa0bbbb0990b
// 082:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 083:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 084:aaaaa0bcaaaaa0bcaaaaa0bcaaaaaa0baaaaaa0baaaaaaa0aaaaaaa0aaaaaaaa
// 085:bbbbbbbbbbbbbbbbbbbbbbbbcbbbbbbbcbbbbbbbbcbbbbbbbcbbbbbb0bcbbbbb
// 086:8bbbbbb88bbbbb8b8bbb88bb8b88bbbbb8bbbbbbb8bbbbbbbbbbbbbbbbbbbbcc
// 087:8b244444bbb24444bbbb2444bbbcb222bbcbbbb8bcbbbb8bcbbbb8bbbbbb8bbb
// 088:44620aaa4620aaaa62b0aaaa8b0aaaaabb0aaaaabb0aaaaab00aaaaab060aaaa
// 089:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 090:0000022200000222000002220000022200000000000000000000000000000000
// 091:2222222222222222222222222222222200000000000000000000000000000000
// 092:2222222222222222222222222222222200000000000000000000000000000000
// 093:2222222222222222222222222222222200000000000000000000000000000000
// 094:2000000020000000200000002000000000000000000000000000000000000000
// 096:b08880bbb08880bbbb000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 097:bbb08880bbb08880bbbb000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 098:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00aaaaa0bb
// 099:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00aaaaaabb0aaaaa
// 100:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 101:0bbcbbbba0bbcbbb0b0bbcbb0fb0bbcc0bfb0bbb0fbfb0bb0bfbfb880fbfbbbb
// 102:bbbbbcbbbbbccbbbbbcbbbbbccbbbb88bbbbb8bbbbb88bbb888bbbbbbbbbbbbb
// 103:bbb80bbbb8800bbb8bb0bbb0bb00bbb0bb0bbbb0b00bbb0bb0bbbb0000bbbb0a
// 104:0bb2000a0b244660bb224460b244260ab224460a044260aa04460aaaa000aaaa
// 105:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 114:aaaa0bbbaaaa0bbbaaa0bbbbaaa0bbbbaa0bbbb0aa0bbbbba0bbbbbba0bbbbbb
// 115:bbb0aaaabbb0aaaabbbb0aaabbbbb0aabbb888000b8cbbbb0b8bcbbb008bcbbb
// 116:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00aaaaa0bb0aaaa0fbb0aa0bb
// 117:00fbbbbb0000bbbb0000000b00000000bb000000fbc00000bcbbbbb0bcbbbbbb
// 118:bbbbbbbbbbbbbbb0bbbbbbb000000000000000000000000000000000bbbbbbbb
// 119:0bbbbb0a0bbbb0aa000000aa000000aa000000aa000000aa0bbbb60abbbbbb60
// 120:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 121:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 130:a0bbbbb00bbbbbb00bbbbbb0a0bbbb0aaa0bb0aaaaa00aaaaaaaaaaaaaaaaaaa
// 131:a0bbbcbbaa0bbcbbaa0fbbcbaaa0fbbcaaaa0fbcaaaa0bfbaaaaa0bbaaaaa0fb
// 132:bbb0a0bbbbbb0bbbbbbb0bbcbbb0bbcbbbb0bbcbcb0bbcbbcbbbbcbbbcbbcbbb
// 133:cbbbbbbbcbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0
// 134:bbbbbbbbbbbbbbbbbbbbbb0bbbbbb0bfbb000bfbb0a0bfbf0aaa0bfbaaaaa0bf
// 135:bbbbbbb6bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 136:0aaaaaaa60aaaaaab60aaaaab6c0aaaabb6c0aaabbb6c0aabbbb60aabbbb6c0a
// 137:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
// 146:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
// 147:aaaaaa0faaaaaa0baaaaaaa0aaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
// 148:bbcbcbbbfbbcbbbbbfbbbbbb0bfbbbbba0bfbbbbaa0bfbbb0000000000000000
// 149:bbbbbb0abbbbb0aabbbb0aaabbb0aaaabb0aaaaab0aaaaaa0000000000000000
// 150:aaaaaa0baaaaaaa0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
// 151:bbbbbbbbbbbbbbbb0bbbbbbba0bbbbbbaa0bbbbbaaa0bbbb0000000000000000
// 152:bbbbb60abbbbb6c0bbbbbb60bbbbbbb6bbbbbbb6bbbbbbbb0000000000000000
// 153:aaaaaaaaaaaaaaaaaaaaaaaa0aaaaaaa0aaaaaaa60aaaaaa0000000000000000
// 160:000ddddd00dccccc0dcccecc0dcceecc0dcccecc0dcccecc0dcceeec00dccccc
// 161:00000000d0000000cd000000cd000000cd000000cd000000cd900000d9990000
// 162:000ddddd00dccccc0dcccecc0dcceecc0dcccecc0dcccecc0dcceeec00dccccc
// 163:00000000d0000000cd000000cd000000cd000000cd000000cd700000d7770000
// 164:000ddddd00dccccc0dcccecc0dcceecc0dcccecc0dcccecc0dcceeec00dccccc
// 165:00000000d0000000cd000000cd000000cd000000cd000000cdb00000dbbb0000
// 166:000ddddd00dccccc0dcccecc0dcceecc0dcccecc0dcccecc0dcceeec00dccccc
// 167:00000000d0000000cd000000cd000000cd000000cd000000cdd00000dddd0000
// 176:000ddddd00000099000000090000000900000000000000000000000000000000
// 177:9999900089999900989999009989999099989990999890909908900090009000
// 178:000ddddd00000077000000070000000700000000000000000000000000000000
// 179:7777700087777700787777007787777077787770777870707708700070007000
// 180:000ddddd000000bb0000000b0000000b00000000000000000000000000000000
// 181:bbbbb0008bbbbb00b8bbbb00bb8bbbb0bbb8bbb0bbb8b0b0bb08b000b000b000
// 182:000ddddd000000dd0000000d0000000d00000000000000000000000000000000
// 183:ddddd0008ddddd00d8dddd00dd8dddd0ddd8ddd0ddd8d0d0dd08d000d000d000
// </SPRITES>

// <MAP>
// 000:101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 001:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 002:1000d100d100d100d100d100d100d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 003:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 004:1000d100d100d100d100d100d100d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 005:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 006:1000d100d100d100d100d100d100d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 007:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 008:1000d100d100d100d100d100d100d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 009:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 010:1000d100d100d100d100d100d100d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 011:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 012:1000d100d100d100d100d100d100d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 013:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 014:1000d100d100d100d100d100d100d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 015:100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 016:101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// </MAP>

// <FLAGS>
// 000:00100000000000000000000000000000000000000000204000000010001000002000000040000000200000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// </FLAGS>

// <PALETTE>
// 000:1a1c2c482704694000895900aa790cd61800fade55f67d0029366f3b5dc941a6f624d679f4f4f494aac6566d85404855
// </PALETTE>

// <COVER>
// 000:b82100007494648393160f00880077000012ffb0e45445353414055423e2033010000000129f40402000ff00c2000000000f00880078989500960400a1c1c265d65849aa6c4f4f4f0484558472406d8100aa97c0b3d59c9263f6146a6f6fd700afed5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080ff001080c181020c0c388031a24585031a087820600189841b0844a831d226cc87113a6cd8f1d367ca83293e64201294e9c49621469449f2952cc59015042c68b037ae42850d0e1ce9e317a040a0028a1d3ae3f7a0d1853d0c087a05908358af45a25daa359aa5dbab55b66d8af51be5598169ce8dea06fc6954b269beada944b86259bd0d8e05c91791ec5cb2790edd2af7bea14eb8079a0c6a306aa35baa8dc6366cf471b3d7c3932b36bc0931f56dc9952b66ec5914f76fc4974f662d891e60deb343070e1c0bb57163cc758ad5ab0b39a165ae012eadfda638bb51ee5987ad1e8cb872f3eacb97455ddad6ff5cd4797e2cdd4dfe225ed5d95fdce98011f2fff6bec9c33f3f6e3db9d1fbebc7b74ffe5d3105d6b1f287bedd1b3eedb3777677ff002265ad08895868a9864022850a96d9d96e063801a18f0a483f144afd5771208a1e68c1e242e9b7c65c72268842207ce5986c9c76228853578e2eb8036c800435604d86362663ed893ae8b3e46d32e8b320993a09c3609d3af864ef8742195323984e09b46b823e49456593324413d10a5e6910c69e5679e5a690668936e797002086e99962a9808a9d62b9e66c9076897047907ed9b66a947699c52d957e1013949656c88042038ab8f164557a1a46e100043af8a99196f939e1053a3a79a5a6006ab9a6ac9a697920099ef95968a99a9ad929a09eaab5eb50110058e1ffa03620408caa1a0889d10a0c1090420e7efa0c60b76ac997eb95c21b6cefa6ce2b4ca0beca5ac0a0a4badab1a35504da4dae49865570c20c04d8c7a89e768bf7ee9e5e9ad92ab0a6abceeabd86badea7a2f6f96e6dbeae342095b8d66ba3539bf2fbdbd34b6969a041cc0c3b80bf98723bb032b17a2b7c63c9030b7fad42ae2600fe45366ce1af6c0a692a67be828ce564a59a9c5239cb5e5cf82aad2f6ac2b7a1378aa238cb1bcc733dc32fac53fec7235828e6cc1f0dd1e6b2158959e4c8033c1173dc4b2be03e9a4bf95131d65fb8436094ee6d3e67d6e2abd528d2f28b36b10c5b8d267dbfe68915eba757e4d041050430f6f59f0569d8e943153ca731ff0c7bedf7f9418f6438364583546e60ae67cd377dd2013e47fbd64310aa6ba44a4503f9a793aa0ae6e997abe9f7a0dee889b8ef4a105af5cd939e5977ec594909b3e004cecd1fb8b276fb2aed49fd4caeeeb1fe87afe2030f97a0f200aec4b1f8c7fe51e0f9c73f7c35e4574bb8bcd193e791b3027b30a45f76be4efea2f2d3ab2ebbba969f563af4e34f8ab9f632bf3e3bb8e3db55300ad710cd3f4edbdad0cdfe0c5fed9c618f8a60fb6898fc0850c36d1051890466d20d180fbcdd95a54dfbde10033455aa0acd0f77d3c0259e67b89e998a0e793bcc190d00f23c4d9035832cdd590558e24412ec65833cdd980186011d0a501b79dabfd601f7ad9dfd0aff6084724d164422fcb3221fc85644a8021997a4c42a31798a6a62e44e981cbd8c1d6a7fa3888f07389fbcb4f0f789f3ba56d6844ea321102c62fbe1da13d7e6463eab4d827c3f5c11e84aba3e19a64f6c22ef8a54f5c23aceae65398984ca15d0b44a3d2a6b845423d895a63339323e4a83c7d02f297099c17e4c55aafc9bb45783b671827394a4f4682f393aae252d4597e235292728e63c426214885cc314d6298bc64ae2f19c8c981f23874d3b4ac2f29304579990e5eeb87913799acc66623f993f21754299937485a037892bb9cd129e49bcf5ee2919ed4e5af2fb95f3c6663d3649191aece76aecfc1b0f5833377682fd9de4e41d395822cb16d33e98ff9a06a5ccc9e83d663b4160ec28673d0afd4d3d2d01a5e408a4ec73f32d3a9dab686367944f2a563c86547d581d846f963a67c0290a60953929a94f4a82d49aa41b4b293cd44cc5d7389aed46a721a921ee85d7379afde8559c59af4f7a04d0aa0578ae137b8b2f27dab1d5e8827ca4bc1bea9abab5a625f479a3dc19ee5975d3a67198ac5deaa75fba20360d3fc684042b61132856dfd5eea08ccbddd85f779c3f72857ea47dab6859b29cc9f9435fa5e2eb289cfa0a24beaf8ca3855b6afca967d4ca2678ab6140a959d686d3be36fc51958cab5918795806663e451b5ca76f3b725a01c31d7f334b6969ca7a53c6a67873a5a1a9ac5b9939b28676bf9d6cff2417a8b65526e617b404dd6f67a825cb22511d4654204d2998885ada2751bb42982d19a6774f36e11ab3d59ee25d9b7742f567bd822d5ea7731b87b36222f856ead66f9ccb2ea38697fb9e15175f4fbb0f5fae0c0aac9c65a8e6aa6a4cfed79eb5acdfeec0592ac45ef7beb69bda6c7f0c445a09f270acd460789e9640dc5ed2579313c1228f2c14d1898773c6c4a7143d3c56b5b58874c026a6643bc51eb4e26875c825d0f2d8cba038137356cf066f6c83c9a4bec2b877c4b49ed9c4f98fc103f3156b23872097e923b32bbc29c24eb1ac697cc3671f3b02cd069a548d69756f6e485bc903d134977cdc5fa53a2d6366b8254dccf5333399dc40252b5b73ff4ad4af2bc9322b21b9264cec411d92e9f5a97b996f9b6af7eb923bedb37e51fc770c45d9a68e649845ef63a11df8e2554afc5b86dc918b0d68ef85a5787b657b6b5d0b29505b5654d49d9c6ba8da0cc7c06a3ac7690f556bfa2859fdbaffa3be0ce4696d7b6b5b169c7a2e55f185ac5a625f9a73b072ebe0b58dab6e4f6a3a7d968ba20b7deb68fa2858c4ad2998fa5b8a5b6b965bd9de22f6bdbd13c77e393adfd506f9ad7b76d82ed658bbb567ff6ddd9e6ed6cb58b17db439b5ad115aee575fdfe3ce6579d61d508ffbb5930787d475bbdddb7f183cb7ed482d83dbf0741f68b1e09c1f65c72e01f143d441efbe653f7d59027ff67254eca2a49d7149afff5493d735e696da07cb3ef89d232439595653d4daac856c93dc71a9ae4dcbc5adda6e0b3374c3a296e78d8e8179877819eb47987985e70def97d638e336c13a77b475f9a56dd163e47064d5aeb8d963b3fe984e57a5b7f99fc6235b1deb6f02ff8bde83b1738d3ce45f70fccd1ce52a2fdc5b4a7fcb3ed5855f679fcd59b16e4337433a8873cb6a8b6f6ee8699f0fd87c3e0960fac5342e4dfc66ac9e5e507b9fd8ce95a79970c57ed07c3dd835e14bfb93ae3512d9553d55a147ba7947ce92dda7647deb5efc93d3ae5caf965678ad97dbf8edb5d7f3a62e70b18f954f47fc933abfdd3e53d75b6b45ca7e83df3f54f10b2d72caca5bf5d4b773fbead85cc2ff2b3bfec6dc69f93bfae36b1f5df2c71fb3fe9dedffefc554bbfca638bf778d6cf7dffbd633ef3c05fffe40b5df4aa62f7cc57611c56c50a7095ae6954c085c3a54a084958e6b080c5be69081879b7508675166807bf66d5df6297028d18028f18c74964bd5374828076732a180e5576226026417f03617505197197757672fd4486d282f5e17306945c279a2f176a39f5b27648f38348a27886127c861f7c38906a96b77c77f773582162581c2d77857c05277f482450c6c87226d47562626547e47847138c471f2f470d4732e48d58916577b77b57ae57580c23784e4f57f68f35267923a67367c46f78b46667c33e78d78188033a462f46a2c58a78e356eff6a574583c2658578537a056779b4e56d880455870387682e2b66f15a66866d986685a8e87c662a8928907a98345697cc21351867761b89763a74b8fa8897d720b81a7c97a17021ca8c559a7ea73b7e45255e867b70b7b458555c8ca7bc82b79c8a55287fb8e58cb79c73e76c69c62c71c7bc35d8be78d8de3bc6bd85c3c882d8625a165856c78b64a69e8ac67e8cc60d79b64e78e8ed81f3dd71d84e8b78708ee7ee8fb7bf85c7de76e7fe7009df87c7309ce78c30f76f87f8b254f7108dd6df7e09ff7ca5bf71e6534aa5cd66197f72192e6408a09e88708618b543f6908de67180293c58005c51294180f6b295290c4e68d19015a53128628cf65395288aff3ef6bf6328739207e18e39228cd5397139b25c07e986a8266947938717238372438705e49a490826a7449d26e38ba4848959859b59727206327a48f59ae23a4548a594960394493d6498758958558937798e07b37fc26165591a5178068259638747a47a68968c68347868d75978869178a69a57117c77789777b57214769139c78488f67199688399546c67788e337674672888885885463e8e89489589b06656a37637598e07516289e899f69798794a87a81a8097f87b878870a8749d63479725ea8172ab89b88b82e2a977b8cb8cb92a72c92864c93c9072b389b97c3a61aa7dc84b70d94c8fe3ac84d9fc96d92c8fc89d98d9d48909cc9165f813c750ff93f8dc68c7f08ac77e9075ad8729704db3f99d196e8bd7ae84e97c4ae32f9ce87f9ee8de8fd8bf94f87e3aa90f99f8209fd8cf840aef870930ab3590ae857e75c6d04c9500aa09c09519ac6ba5ee861a8a39f7a1941a1d3a1ad1a319008177c19fd9545a51808a292182f6d297c555401872ace9e2a62981855142a525c18249428049d39407b3983a539c3993943914a04af6404a30053a584f28ea9b4ad49079949089c53838d53bc99b9786c59292527406006b5a7a4a5ae5a048948e5995a99855a1582a9858a89e6976ac69413fe921a679f4a749779468f7927a17ab796e305aea3ed9fd9f8876a536657989498b89c54c7acc9f89a2329909949963ff35f7e8ae67c8a899b8a59909a39a633e6a7f8e7af7aa58059a6a2a9c6ac8968a55aca9fa977a7639a84b96b9849197aaa728ba853a649f72db90c9fb92ba5c98c97c90723ba6ba086bb8e97d8245a47965a1d9fe3a863c8155cd9655ad96b72d98cac746cadca0d2d8910a1370e81186097da3f82e91e8c449e74f950a9da3a3e3784adc9fc74f37d78eacd76d7aeafe30f88d7fea11a99a1a91f83e94fa60a40980a8e74c69627d86fa1eadfa46a2caa9681ae3671951a60bf1ad0912afa5019d24819f09f0b3083ea84ae7a929ffa018429c2a4c513ad08a2a92ac29f1b32958a91841b4aac3a93a72bb3a607d3aaa8c2bb28a2bd2b14a839d74a3ae414effa773a4aa7abe5836da9a7ad9ac3b5aa1ca5593ca85a54bc5ab9406a56964bd5adf5369427f52c825062aa20b5dab69805b9ad6918ac56e72d00cb2eb2ba331b53af586aa6f54479a267ada947ae7997a647df3e6610b34b3fad5753885bf3b47bfb2d0097be00b7a42b26b30b19a446d8aa99c99a8a98a08b3a5f8a56748b688b92d5b2a289a4e8a9a90318a85b298e4aa84fc219207b86962ba3b3b9463daa46ba870ab8aa4ab2b99478b984a131babb21cabe21dab0bbfab2bb2211bb4bb3bba217bbd21e1173b5ea022b220f1822722fbba229223223cb322cbb2a5c02acb902702ecb312bcb1dbdcb0db3db11209b2d87cb1cbebb5cbadb0cb9dbfdbcd55bb9b0a92cb1eb5eb4eb7ebbdb8ebedb1fa19b2dbb025dbccbfeb2fba024fbfcb6db0fbeeb5fb2119cb6eb9ebefbbebaeb4cb10c6cbceb8dba4270c94290c05280cb0ca0c542d0c01cf0c21cd42b4251cf74f56101000b3
// </COVER>
