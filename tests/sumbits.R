# https://codereview.stackexchange.com/a/38229
# int CountOnesFromInteger(uint32_t i)
# {
#     i = i - ((i >> 1) & 0x55555555);
#     i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
#     return (((i + (i >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
# }

bitOnes = function(i) {
    i = i - bitwAnd(bitwShiftR(i, 1L), 0x55555555)
    i = bitwAnd(i, 0x33333333) + bitwAnd(bitwShiftR(i, 2L), 0x33333333)
    return(bitwShiftR(bitwAnd((i + bitwShiftR(i, 4L)), 0x0F0F0F0F) * 0x01010101, 24L))
}
