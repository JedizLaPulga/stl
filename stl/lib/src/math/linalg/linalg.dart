/// General linear algebra module — `<linalg>`.
///
/// Provides a C++26 `std::linalg`-inspired set of types and free functions for
/// general M×N real matrix computations:
///
/// - [Vec] — immutable $n$-dimensional real vector.
/// - [Mat] — immutable general M×N real matrix.
/// - [LUDecomposition], [QRDecomposition], [CholeskyDecomposition] — matrix
///   factorisations.
/// - [dot], [nrm2], [asum], [iamax], [axpy], [scal], [gemv], [ger], [gemm],
///   [trmm] — BLAS Level 1/2/3 free functions.
/// - [EigenResult], [powerIteration], [symmetricEigen], [qrEigen] — eigenvalue
///   solvers.
library;

export 'vec.dart';
export 'matrix.dart';
export 'decomposition.dart';
export 'blas.dart';
export 'eigen.dart';
