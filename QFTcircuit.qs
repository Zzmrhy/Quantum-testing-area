import Std.Arrays.IndexRange;
import Std.Diagnostics.DumpMachine;
import Microsoft.Quantum.Diagnostics.*;
import Microsoft.Quantum.Math.*;
import Microsoft.Quantum.Arrays.*;

operation Main() : Result[] {
    mutable resultArray = [Zero, size = 3];

    use qs = Qubit[3];

    H(qs[0]);

    Controlled R1([qs[1]], (PI()/2.0, qs[0]));
    Controlled R1([qs[2]], (PI()/4.0, qs[0]));

    H(qs[1]);
    Controlled R1([qs[2]], (PI()/2.0, qs[1]));

    H(qs[2]);

    SWAP(qs[2], qs[0]);

    Message("Before measurement: ");
    DumpMachine();

    for i in IndexRange(qs) {
        set resultArray w/= i <- M(qs[i]);
    }

    Message("After measurement: ");
    DumpMachine();

    ResetAll(qs);
    Message("Post-QTF measurement results [qubit0, qubit1, qubit2]: ");
    return resultArray;
}