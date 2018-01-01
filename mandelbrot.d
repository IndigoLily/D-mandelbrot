import std.complex;
import std.stdio;
import std.conv;
import std.math;

void main(string[] args) {
    immutable uint MAX = 1000;
    uint width  = 400;
    uint height = 400;
    uint small  = (width < height) ? width : height;
    real zoom = 512;
    immutable ubyte AA = 1;
    real posR = -0.757843017578125;
    real posI =  0.073272705078125;

    ubyte[] imageData;
    foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
            real sumR = 0;
            real sumG = 0;
            real sumB = 0;

            foreach (xAA; 0 .. AA) {
                foreach (yAA; 0 .. AA) {
                    Complex!real c;
                    c.re = (x + real(xAA) / AA - width  / 2) / small * 4 / zoom + posR;
                    c.im = (y + real(yAA) / AA - height / 2) / small * 4 / zoom + posI;
                    Complex!real z = 0;

                    uint i = 0;
                    for (; i < MAX && z.re * z.re + z.im * z.im < 4; ++i) {
                        z = z * z + c;
                    }

                    if (i != MAX) {
                        sumR += (1 + cos(i * PI / 110.0L)) / 2 * 0xFF;
                        sumG += (1 + cos(i * PI / 120.0L)) / 2 * 0xFF;
                        sumB += (1 + cos(i * PI / 130.0L)) / 2 * 0xFF;
                    }
                }
            }

            imageData ~= cast(ubyte)(sumR / AA / AA);
            imageData ~= cast(ubyte)(sumG / AA / AA);
            imageData ~= cast(ubyte)(sumB / AA / AA);
        }

        writeln("Render: ", y.to!real / height * 100, r"% done");
    }

    toFile(imageData, "mandelbrot.raw");
}
