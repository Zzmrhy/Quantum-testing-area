import Microsoft.Quantum.Intrinsic.*;
import Microsoft.Quantum.Canon.*;

operation SetQubitState(desired : Result, target : Qubit) : Unit {
    if desired != M(target) {
        X(target);
    }
}

operation Main() : (Int, Int, Int, Int) {
    mutable numOnesQ1 = 0;
    mutable numOnesQ2 = 0;
    let count = 1000;
    let intial = One;

    use (q1, q2) = (Qubit(), Qubit());
    for test in 1..count {
        SetQubitState(intial, q1);
        SetQubitState(Zero, q2);

        H(q1);
        CNOT(q1, q2);

        let resultQ1 = M(q1);
        let resultQ2 = M(q2);

        if resultQ1 == One {
            set numOnesQ1 += 1;
        }

        if resultQ2 == One {
            set numOnesQ2 += 1;
        }
    }

    SetQubitState(Zero, q1);
    SetQubitState(Zero, q2);

    Message($"Q1 - Zeros: {count - numOnesQ1}");
    Message($"Q1 - Ones: {numOnesQ1}");
    Message($"Q2 - Zeros: {count - numOnesQ2}");
    Message($"Q2 - Ones: {numOnesQ2}");

    return (count - numOnesQ1, numOnesQ1, count - numOnesQ2, numOnesQ2);
}