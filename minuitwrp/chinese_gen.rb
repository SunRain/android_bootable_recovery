#!/usr/bin/ruby

require 'rubygems'
require 'iconv'
require 'RMagick'
include Magick

s = ''
# basic printable
for i in 32...128
    s = "%s%c" % [ s, i ]
end

# gen needed character using gperf
c = ''
count = s.length

# chinese punct
for j in 0xa1..0xfe
    ch = "%c%c" % [ 0xa1, j ]
    c += ch
    count += 1
end
# full width ascii
for j in 0xa1..0xfe
    ch = "%c%c" % [ 0xa3, j ]
    c += ch
    count += 1
end
# hiragana
for j in 0xa1..0xf3
    ch = "%c%c" % [ 0xa4, j ]
    c += ch
    count += 1
end
# katakana
for j in 0xa1..0xf6
    ch = "%c%c" % [ 0xa5, j ]
    c += ch
    count += 1
end
# common simplified chinese charaters
for i in 0xb0..0xd6
    for j in 0xa1..0xfe
        ch = "%c%c" % [ i, j ]
        c += ch
        count += 1
    end
end
for j in 0xa1..0xf8
    ch = "%c%c" % [ 0xd7, j ]
    c += ch
    count += 1
end

ch = "%c%c" % [ 0xe4, 0xaf ]
c += ch
count += 1

# gen a **huge** bitmap
count -= s.length
char_width = 20
char_height = 50
asc_width = char_width * s.length
cjk_width = count * 2 * char_width
img_width = asc_width + cjk_width
img_height = char_height
canvas = Image.new(img_width, img_height)
# so, bitmap font is better...
text = Draw.new
text.gravity = WestGravity
text.pointsize = 40
text.font = 'simhei.ttf'
p "painting basic ascii"
for i in 0...96
    ch = s[i, 1]
    # what a fuck
    ch = "\\\\" if ch == "\\"
    text.annotate(canvas, char_width, char_height, i * char_width, 0, ch)
end
text.font = 'yahei.ttf'
p "painting extra characters"
for i in 0...count
    ch = Iconv.iconv('utf-8', 'gb2312', c[i * 2, 2])[0]
    text.annotate(canvas, char_width * 2, char_height, i * char_width * 2 + asc_width, 0, ch)
end
p "writing preview file"
canvas.write('chinese.png')
p "encoding pixels"
pixels = []
n = 0
k = 0
run_count = 1
run_val = ""
canvas.each_pixel { |p, x, y|
    r = (p.red < 0xC000)
    if run_val != ""
	val = r ? 0x80 : 0x00
	    if (val == run_val) && (run_count < 127)
		run_count += 1
	    else
		k += run_count
		pixels.push(run_count | run_val)
		run_val = val
		run_count = 1
	    end
    else
	run_val = r ? 0x80 : 0x00
    end
}
k += run_count
pixels.push(run_count | run_val)
pixels.push(0)
p "generating header files"
# gen font data
f = File.open('font.h', 'w')
f.write("struct {\n")
f.write("\tunsigned width;\n")
f.write("\tunsigned height;\n")
f.write("\tunsigned cwidth;\n")
f.write("\tunsigned cheight;\n")
f.write("\tunsigned char rundata[];\n")
f.write("} font = {\n")
f.write("\t.width = #{img_width},\n")
f.write("\t.height = #{img_height},\n")
f.write("\t.cwidth = #{char_width},\n")
f.write("\t.cheight = #{char_height},\n")
f.write("\t.rundata = {\n")
n = 0
pixels.each { |b|
    f.write(("0x%02x, " % [ b ]))
    n += 1
    f.write("\n") if n  % 16 == 0
}
f.write("\t}\n")
f.write('};')
f.close

