import std.complex;
import std.stdio;
import std.conv;
import std.math;
import std.getopt;
import std.file;

void main(string[] args) {
    uint max = 1000;
    uint width  = 400;
    uint height = 400;
    real zoom = 1;
    ubyte aa = 1;
    real posR = 0;
    real posI = 0;

    getopt(args,
            "iterations|itr", &max,
            "width|w", &width,
            "height|h", &height,
            "zoom|z", &zoom,
            "aa|a", &aa,
            "x|r", &posR,
            "y|i", &posI);

    uint small  = (width < height) ? width : height;

    ubyte[] imageData;
    foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
            real sumR = 0;
            real sumG = 0;
            real sumB = 0;

            foreach (xaa; 0 .. aa) {
                foreach (yaa; 0 .. aa) {
                    Complex!real c;
                    c.re = (x + real(xaa) / aa - width  / 2) / small * 4 / zoom + posR;
                    c.im = (y + real(yaa) / aa - height / 2) / small * 4 / zoom - posI;
                    Complex!real z = 0;

                    uint itr = 0;
                    for (; itr < max && z.re^^2 + z.im^^2 < 4; ++itr) {
                        z = z * z + c;
                    }

                    if (itr < max) {
                        sumR += (1 + cos(itr * PI / 101.0L)) / 2 * 0xFF;
                        sumG += (1 + cos(itr * PI / 102.0L)) / 2 * 0xFF;
                        sumB += (1 + cos(itr * PI / 103.0L)) / 2 * 0xFF;
                    }
                }
            }

            imageData ~= cast(ubyte)(sumR / aa / aa);
            imageData ~= cast(ubyte)(sumG / aa / aa);
            imageData ~= cast(ubyte)(sumB / aa / aa);
        }

        writeln("Render: ", y.to!real / height * 100, r"% done");
    }

    string filename = "mandelbrot " ~ to!string(width) ~ "x" ~ to!string(height) ~ " ";
    size_t n = 0;
    while (exists(filename ~ to!string(++n) ~ ".raw")) {}
    toFile(imageData, filename ~ to!string(n) ~ ".raw");
}
