import Std.Convert.ResultArrayAsInt;
import Microsoft.Quantum.Convert.*;
import Microsoft.Quantum.Math.*;

operation Main() : Int {
    let max = 100;
    Message($"Sampling a random number between 0 and {max}");

    return GenerateRandomNumberInRange(max)
}

operation GenerateRandomNumberInRange(max : Int) : Int {
    mutable bits = [];

    let nBits = BitSizeI(max);

    for idxBit in 1..nBits {
        set bits += [GenerateRandomBit()];
    }

    let sample = ResultArrayAsInt(bits);

    return sample > max ? GenerateRandomNumberInRange(max) | sample;
}

operation GenerateRandomBit() : Result {
    use q = Qubit();

    H(q);

    let result = M(q);

    Reset(q);

    return result;
}
