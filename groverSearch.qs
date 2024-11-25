import Std.Arrays.Tail;
import Microsoft.Quantum.Convert.*;
import Microsoft.Quantum.Math.*;
import Microsoft.Quantum.Arrays.*;
import Microsoft.Quantum.Measurement.*;
import Microsoft.Quantum.Diagnostics.*;


operation Main() : Result[] {
    let nQubits = 5;
    let iterations = CalculateOptimalIterations(nQubits);
    Message($"Number of iterations: {iterations}");

    let results = GroverSearch(nQubits, iterations, ReflectAboutMarked);
    return results;
}

operation ReflectAboutMarked(inputQubits : Qubit[]) : Unit {
    Message("Reflecting about marked state...");
    use outputQubit = Qubit();
    within {
        X(outputQubit);
        H(outputQubit);

        for q in inputQubits[...2...] {
            X(q);
        }
    } apply {
        Controlled X(inputQubits, outputQubit);
    }
}

function CalculateOptimalIterations(nQubits : Int) : Int {
    if nQubits > 63 {
        fail "This sample supports at most 63 qubits.";
    }

    let nItems = 1 <<< nQubits; // 2^nQubits
    
    let angle = ArcSin(1. / Sqrt(IntAsDouble(nItems)));

    let iterations = Round(0.25 * PI() / angle - 0.5);

    return iterations;
}

operation GroverSearch( nQubits : Int, iterations : Int, phaseOracle : Qubit[] => Unit) : Result[] {
    use qubits = Qubit[nQubits];

    PrepareUniform(qubits);

    for _ in 1..iterations {
        phaseOracle(qubits);
        ReflectAboutUniform(qubits);
    }

    return MResetEachZ(qubits);
}

operation PrepareUniform(inputQubits : Qubit[]) : Unit is Adj + Ctl {
    for q in inputQubits {
        H(q);
    }
}

operation ReflectAboutAllOnes(inputQubits : Qubit[]) : Unit {
    Controlled Z(Most(inputQubits), Tail(inputQubits));
}

operation ReflectAboutUniform(inputQubits : Qubit[]) : Unit {
    within {
        Adjoint PrepareUniform(inputQubits);

        for q in inputQubits {
            X(q);
        } 
    } apply {
        ReflectAboutAllOnes(inputQubits);
    }
}