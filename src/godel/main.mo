import Array "mo:base/Array";
import Int "mo:base/Int";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Float "mo:base/Float";
import Debug "mo:base/Debug";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor {

    private func quicksort(
            xs : [var Int],
            l : Int,
            r : Int
        ) {
            if (l < r) {
                var i = l;
                var j = r;
                var swap  = xs[0];
                let pivot = xs[Int.abs(l + r) / 2];
                while (i <= j) {
                    while (xs[Int.abs(i)] < pivot) {
                        i += 1;
                    };
                    while (xs[Int.abs(j)] > pivot) {
                        j -= 1;
                    };
                    if (i <= j) {
                    swap := xs[Int.abs(i)];
                    xs[Int.abs(i)] := xs[Int.abs(j)];
                    xs[Int.abs(j)] := swap;
                    i += 1;
                    j -= 1;
                    };
                };
                if (l < j) {
                    quicksort(xs, l, j);
                };

                if (i < r) {
                    quicksort(xs, i, r);
                };
            };
    };


    public func qsort(xs : [Int]) : async [Int] {
        let n = xs.size();

        if (n < 2) {
            return xs;
        } else {
            let result:[var Int] = Array.thaw(xs);
            quicksort(result, 0, n - 1);
            return Array.freeze(result);
        };
    };


    // 第三课作业
    // counter
    stable var currentValue : Nat = 0;

    // Increment the counter with the increment function.
    public func increment() : async () {
        currentValue += 1;
    };

    // Read the counter value with a get function.
    public query func getCurrentValue() : async Nat {
        currentValue
    };

    // Write an arbitrary value with a set function.
    public func setCurrentValue(n: Nat) : async () {
        currentValue := n;
    };



    // request counter

    private type HeaderField = (Text, Text);
    private type HttpRequest = {
        url: Text;
        method: Text;
        body: [Nat8];
        headers: [HeaderField];
    };
    private type Key = Text;
    private type Path = Text;
    private type ChunkId = Nat;
    private type SetAssetContentArguments = {
        key : Key;
        sha256: ?[Nat8];
        chunk_ids: [ChunkId];
    };
    private type StreamingCallbackToken = {
        key: Text;
        sha256: ?[Nat8];
        index: Nat;
        content_encoding: Text;
    };
    private type StreamingCallbackHttpResponse = {
        token: ?StreamingCallbackToken;
        body: [Nat8];
    };
    private type StreamingStrategy = {
        #Callback: {
            token: StreamingCallbackToken;
            callback: shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
        };
    };
    private type HttpResponse = {
        body: Blob;
        headers: [HeaderField];
        streaming_strategy: ?StreamingStrategy;
        status_code: Nat16;
    };
    public shared query func http_request(request: HttpRequest): async HttpResponse {
        {
            body = Text.encodeUtf8("<html><body><h1>" #Nat.toText(currentValue)# "</h1></body></html>");
            headers = [];
            streaming_strategy = null;
            status_code = 200;
        }
    };

}