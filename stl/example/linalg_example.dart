// ignore_for_file: avoid_print

import 'package:stl/stl.dart';

void main() {
  _section('Vec — basic operations');
  final u = Vec([1.0, 2.0, 3.0]);
  final v = Vec([4.0, 5.0, 6.0]);
  print('u          = $u');
  print('v          = $v');
  print('u + v      = ${u + v}');
  print('u - v      = ${u - v}');
  print('u * 2      = ${u * 2.0}');
  print('dot(u,v)   = ${u.dot(v)}');
  print('cross(u,v) = ${u.cross(v)}');
  print('||u||_2    = ${u.norm().toStringAsFixed(6)}');
  print('normalize  = ${u.normalize()}');
  print('');

  _section('Vec — outer product');
  final outer = u.outer(Vec([1.0, 0.0]));
  print('u ⊗ [1,0] =\n$outer');
  print('');

  _section('Mat — constructors and access');
  final I3 = Mat.identity(3);
  print('Identity(3) =\n$I3');
  final A = Mat([
    [2.0, 1.0, -1.0],
    [-3.0, -1.0, 2.0],
    [-2.0, 1.0, 2.0],
  ]);
  print('A =\n$A');
  print('A.row(0) = ${A.row(0)}');
  print('A.col(2) = ${A.col(2)}');
  print('A.at(1,2) = ${A.at(1, 2)}');
  print('trace(A) = ${A.trace()}');
  print('frobenius(A) = ${A.frobenius().toStringAsFixed(6)}');
  print('det(A) = ${A.determinant().toStringAsFixed(6)}');
  print('');

  _section('Mat — arithmetic');
  final B = Mat([
    [1.0, 0.0, 1.0],
    [0.0, 1.0, 0.0],
    [1.0, 0.0, 1.0],
  ]);
  print('A + B =\n${A + B}');
  print('A * B =\n${A * B}');
  print('A.transpose() =\n${A.transpose()}');
  print('');

  _section('Mat — inverse');
  final C = Mat([
    [2.0, 1.0],
    [5.0, 3.0],
  ]);
  final Cinv = C.inverse();
  print('C =\n$C');
  print('C^-1 =\n$Cinv');
  print('C * C^-1 =\n${_roundMat(C * Cinv)}');
  print('');

  _section('LU Decomposition');
  final lu = LUDecomposition(A);
  print('L =\n${_roundMat(lu.l)}');
  print('U =\n${_roundMat(lu.u)}');
  print('P =\n${_roundMat(lu.p)}');
  print('P * L * U (should equal A) =\n${_roundMat(lu.p * lu.l * lu.u)}');
  final bVec = Vec([8.0, -11.0, -3.0]);
  final xLU = lu.solve(bVec);
  print('Solve A*x = [8,-11,-3]: x = $xLU  (expected [2,3,-1])');
  print('det(A) via LU = ${lu.determinant().toStringAsFixed(6)}');
  print('');

  _section('QR Decomposition');
  final M = Mat([
    [12.0, -51.0, 4.0],
    [6.0, 167.0, -68.0],
    [-4.0, 24.0, -41.0],
  ]);
  final qr = QRDecomposition(M);
  print('Q^T * Q (should be I) =\n${_roundMat(qr.q.transpose() * qr.q)}');
  print('R =\n${_roundMat(qr.r)}');
  print('Q * R (should equal M) =\n${_roundMat(qr.q * qr.r)}');
  print('');

  _section('Cholesky Decomposition');
  final spd = Mat([
    [4.0, 12.0, -16.0],
    [12.0, 37.0, -43.0],
    [-16.0, -43.0, 98.0],
  ]);
  final chol = CholeskyDecomposition(spd);
  print('L =\n${_roundMat(chol.l)}');
  print(
    'L * L^T (should equal A) =\n${_roundMat(chol.l * chol.l.transpose())}',
  );
  final xChol = chol.solve(Vec([1.0, 0.0, 0.0]));
  print('Solve Ax = [1,0,0]: x = $xChol');
  print('');

  _section('BLAS Level 1');
  final p = Vec([1.0, 2.0, 3.0]);
  final q = Vec([4.0, 5.0, 6.0]);
  print('dot(p,q)   = ${dot(p, q)}');
  print('nrm2(p)    = ${nrm2(p).toStringAsFixed(6)}');
  print('asum(p)    = ${asum(p)}');
  print('iamax(p)   = ${iamax(p)}');
  print('axpy(2,p,q)= ${axpy(2.0, p, q)}');
  print('scal(3,p)  = ${scal(3.0, p)}');
  print('');

  _section('BLAS Level 2: gemv');
  final D = Mat([
    [1.0, 2.0],
    [3.0, 4.0],
  ]);
  final w = Vec([1.0, 2.0]);
  final y0 = gemv(D, w);
  print('D * w (gemv) = $y0');
  final y1 = gemv(D, w, alpha: 2.0, beta: 1.0, y: Vec([10.0, 20.0]));
  print('2*(D*w) + [10,20] = $y1');
  print('');

  _section('BLAS Level 2: ger');
  final outer2 = ger(Vec([1.0, 2.0]), Vec([3.0, 4.0]));
  print('ger([1,2],[3,4]) =\n$outer2');
  print('');

  _section('BLAS Level 3: gemm');
  final E = Mat([
    [1.0, 2.0],
    [3.0, 4.0],
  ]);
  final F = Mat([
    [5.0, 6.0],
    [7.0, 8.0],
  ]);
  print('gemm(E, F) =\n${gemm(E, F)}');
  print(
    'gemm with alpha=2, beta=1, C=I =\n${gemm(E, F, alpha: 2.0, beta: 1.0, c: Mat.identity(2))}',
  );
  print('');

  _section('BLAS Level 3: trmm');
  final upper = Mat([
    [2.0, 3.0],
    [0.0, 4.0],
  ]);
  final col = Mat([
    [1.0],
    [1.0],
  ]);
  print('trmm(upper, [1;1]) = ${trmm(upper, col).col(0)}  (expected [5,4])');
  print('');

  _section('Eigenvalue Solvers');
  final sym = Mat([
    [3.0, 1.0],
    [1.0, 3.0],
  ]);
  final (lambda, v2) = powerIteration(sym);
  print(
    'powerIteration([[3,1],[1,3]]): λ=${lambda.toStringAsFixed(6)}, v=$v2  (expected λ≈4)',
  );

  final eigResult = symmetricEigen(sym);
  print(
    'symmetricEigen eigenvalues: ${eigResult.eigenvalues.map((e) => e.toStringAsFixed(4)).toList()}  (expected [4,2])',
  );
  print('eigenvectors (columns):\n${_roundMat(eigResult.eigenvectors)}');

  final diag = Mat.diagonal([5.0, 3.0, 1.0]);
  final qrResult = qrEigen(diag);
  print(
    'qrEigen(diag [5,3,1]) eigenvalues: ${qrResult.eigenvalues.map((e) => e.toStringAsFixed(4)).toList()}',
  );
  print('');
}

// ─── helpers ──────────────────────────────────────────────────────────────────

void _section(String title) {
  print('─' * 60);
  print('  $title');
  print('─' * 60);
}

/// Rounds matrix entries to 4 decimal places to suppress floating-point noise.
Mat _roundMat(Mat m) {
  return Mat(
    List.generate(
      m.rows,
      (i) => List.generate(m.cols, (j) {
        final v = m.at(i, j);
        return (v * 1e4).round() / 1e4;
      }),
    ),
  );
}
