# Parallel Pi Calculator

A high-performance Fortran program that computes as many digits of π (pi)
as will fit in your system's available RAM, using all available CPU cores.

## Overview

This program uses the **Chudnovsky algorithm** combined with **Binary
Splitting** to compute π to millions of decimal places. The computation
is parallelized across all available CPU cores using **OpenMP tasks**,
and arbitrary-precision arithmetic is provided by the **GNU Multiple
Precision (GMP)** library.

The program automatically detects how much free RAM is available, estimates
the maximum number of digits that can be computed within 40% of that memory,
performs the multi-threaded calculation, and reports the results including
total digit count and elapsed time.

## Algorithm

The Chudnovsky series (discovered in 1988) is one of the fastest known
algorithms for computing π, converging at approximately **14.18 digits per
term**. It is the same algorithm used in most world-record π calculations.

Binary splitting converts the series sum into a divide-and-conquer tree of
triple merges (P, Q, T), reducing overall complexity to **O(n log² n)**.
Each recursive branch is dispatched as an independent OpenMP task.

## Dependencies

| Dependency | Purpose |
|------------|---------|
| GNU Fortran (gfortran) 5.0+ | Compiler with OpenMP support |
| GMP (libgmp) 5.0+ | Arbitrary-precision arithmetic |
