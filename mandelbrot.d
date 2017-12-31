import std.complex;
import std.stdio;
import std.conv;

void main() {
    immutable uint MAX = 1000;
    immutable uint RES = 2560;
    immutable ubyte AA = 2;

    ubyte[] imageData;
    foreach (y; 0 .. RES) {
        foreach (x; 0 .. RES) {
            uint sumR = 0;
            uint sumG = 0;
            uint sumB = 0;

            foreach (xAA; 0 .. AA) {
                foreach (yAA; 0 .. AA) {
                    Complex!real c;
                    c.re = (x + real(xAA) / AA - RES / 2) / RES * 4;
                    c.im = (y + real(yAA) / AA - RES / 2) / RES * 4;
                    Complex!real z = 0;

                    uint i = 0;
                    for (; i < MAX && z.re * z.re + z.im * z.im < 4; ++i) {
                        z = z * z + c;
                    }

                    if (i != MAX) {
                        sumR += i * 10 % 0xFF;
                        sumG += i * 20 % 0xFF;
                        sumB += i * 30 % 0xFF;
                    }
                }
            }

            imageData ~= cast(ubyte)(real(sumR) / AA / AA);
            imageData ~= cast(ubyte)(real(sumG) / AA / AA);
            imageData ~= cast(ubyte)(real(sumB) / AA / AA);
        }

        writeln("Render: ", y.to!real / RES * 100, r"% done");
    }

    toFile(imageData, "mandelbrot.raw");
}
