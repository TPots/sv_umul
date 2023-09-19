# sv_umul
A module for overflow protected, unsigned integer multiplication.

## Parameters

|Signal    | Description                             |
|----------|-----------------------------------------|
|`DATA_WIDTH`|Parameterizes the width of the IO signals| 

## Inputs

|Signal | Size      |Description            |
|-------|-----------|-----------------------|
|`in0`  |`DATA_WIDTH`|First unsigned integer |
|`in1`  |`DATA_WIDTH`|Second unsigned integer|

## Outputs

|Signal  |Size      |Description            |
|--------|----------|-----------------------|
|`out`   |`DATA_WIDTH`|Product of the input signals `in0` and `in1`. If `out` can not store the product of `in0` and `in1`, `out` is equal to the maximum value it is able to store (i.e., $2^n$ where $n=$`DATA_WIDTH`)|
|`ov`    |`DATA_WIDTH`|Overflow value equal to the difference between the maximum value `out` iff `sig_ov` is `true`           |
|`sig_ov`|1           |Signals overflow to the instantiator of the module|

![waveform](doc/wave.png)
