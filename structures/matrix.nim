import math, random, strutils

template checkBounds(cond: untyped, msg = "") =
   when compileOption("boundChecks"):
      {.line.}:
         if not cond:
            raise newException(IndexError, msg)

template newData() =
   newSeq(result.data, result.m)
   for i in 0 ..< result.m:
      newSeq(result.data[i], result.n)

type Matrix* = object
   # Array for internal storage of elements.
   data: seq[seq[float]]
   # Row and column dimensions.
   m*, n*: int

# Construct an m-by-n matrix of zeros. 
proc matrix*(m, n: int): Matrix =
   result.m = m
   result.n = n
   newData()

# Construct an m-by-n constant matrix.
proc matrix*(m, n: int, s: float): Matrix =
   result.m = m
   result.n = n
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         result.data[i][j] = s

# Construct a matrix from a 2-D array.
proc matrix*(data: seq[seq[float]]): Matrix =
   result.m = data.len
   result.n = data[0].len
   when compileOption("assertions"):
      for i in 0 ..< result.m:
         assert(data[i].len == result.n, "All rows must have the same length.")
   result.data = data

# Construct a matrix from a one-dimensional packed array
# data One-dimensional array of float, packed by columns (ala Fortran).
# Array length must be a multiple of m.
proc matrix*(data: seq[float], m: int): Matrix =
   result.m = m
   result.n = if m != 0: data.len div m else: 0
   assert result.m * result.n == data.len, "Array length must be a multiple of m."
   newData()
   for i in 0 ..< m:
      for j in 0 ..< result.n:
         result.data[i][j] = data[i + j * m]

# Copy the internal two-dimensional array.
proc getArray*(m: Matrix): seq[seq[float]] =
   result = m.data

# Make a one-dimensional column packed copy of the internal array.
proc getColumnPacked*(m: Matrix): seq[float] =
   newSeq(result, m.m * m.n)
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result[i + j * m.m] = m.data[i][j]

# Make a one-dimensional row packed copy of the internal array.
proc getRowPacked*(m: Matrix): seq[float] =
   newSeq(result, m.m * m.n)
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result[i * m.n + j] = m.data[i][j]

# Get row dimension.
proc rowDimension*(m: Matrix): int =
   m.m

# Get column dimension.
proc columnDimension*(m: Matrix): int =
   m.n

# Get a single element.
proc `[]`*(m: Matrix, i, j: int): float =
   m.data[i][j]

# Get a submatrix.
#   m[i0 .. i1, j0 .. j1]
proc `[]`*(m: Matrix, r, c: Slice[int]): Matrix =
   checkBounds(r.a >= 0 and r.b < m.m, "Submatrix dimensions")
   checkBounds(c.a >= 0 and c.b < m.n, "Submatrix dimensions")
   result.m = r.b - r.a + 1
   result.n = c.b - c.a + 1
   newData()
   for i in r.a .. r.b:
      for j in c.a .. c.b:
         result.data[i - r.a][j - c.a] = m.data[i][j]

# Get a submatrix.
#   m[[0, 2, 3, 4], [1, 2, 3, 4]]
proc `[]`*(m: Matrix, r, c: openarray[int]): Matrix =
   checkBounds(r.len <= m.m, "Submatrix dimensions")
   checkBounds(c.len <= m.n, "Submatrix dimensions")
   result.m = r.len
   result.n = c.len
   newData()
   for i in 0 ..< r.len:
      for j in 0 ..< c.len:
         result.data[i][j] = m.data[r[i]][c[j]]

# Get a submatrix.
#   m[i0 .. i1, [0, 2, 3, 4]]
proc `[]`*(m: Matrix, r: Slice[int], c: openarray[int]): Matrix =
   checkBounds(r.a >= 0 and r.b < m.m, "Submatrix dimensions")
   checkBounds(c.len <= m.n, "Submatrix dimensions")
   result.m = r.b - r.a + 1
   result.n = c.len
   newData()
   for i in r.a .. r.b:
      for j in 0 ..< c.len:
         result.data[i - r.a][j] = m.data[i][c[j]]

# Get a submatrix.
#   m[[0, 2, 3, 4], j0 .. j1]
proc `[]`*(m: Matrix, r: openarray[int], c: Slice[int]): Matrix =
   checkBounds(r.len <= m.m, "Submatrix dimensions")
   checkBounds(c.a >= 0 and c.b < m.n, "Submatrix dimensions")
   result.m = r.len
   result.n = c.b - c.a + 1
   newData()
   for i in 0 ..< r.len:
      for j in c.a .. c.b:
         result.data[i][j - c.a] = m.data[r[i]][j]

# Set a single element.
proc `[]=`*(m: var Matrix, i, j: int, s: float) =
   m.data[i][j] = s

# Set a submatrix.
#   m[i0 .. i1, j0 .. j1] = a
proc `[]=`*(m: var Matrix, r, c: Slice[int], a: Matrix) =
   checkBounds(r.b - r.a + 1 == a.m, "Submatrix dimensions")
   checkBounds(c.b - c.a + 1 == a.n, "Submatrix dimensions")
   for i in r.a .. r.b:
      for j in c.a .. c.b:
         m.data[i][j] = a.data[i - r.a][j - c.a]

# Set a submatrix.
proc `[]=`*(m: var Matrix, r, c: openarray[int], a: Matrix) =
   checkBounds(r.len == a.m, "Submatrix dimensions")
   checkBounds(c.len == a.n, "Submatrix dimensions")
   for i in 0 ..< r.len:
      for j in 0 ..< c.len:
         m.data[r[i]][c[j]] = a.data[i][j]

# Set a submatrix.
#   m[[0, 2, 3, 4], j0 .. j1] = a
proc `[]=`*(m: var Matrix, r: openarray[int], c: Slice[int], a: Matrix) =
   checkBounds(r.len == a.m, "Submatrix dimensions")
   checkBounds(c.b - c.a + 1 == a.n, "Submatrix dimensions")
   for i in 0 ..< r.len:
      for j in c.a .. c.b:
         m.data[r[i]][j] = a.data[i][j - c.a]

# Set a submatrix.
#   m[i0 .. i1, [0, 2, 3, 4]] = a
proc `[]=`*(m: var Matrix, r: Slice[int], c: openarray[int], a: Matrix) =
   checkBounds(r.b - r.a + 1 == a.m, "Submatrix dimensions")
   checkBounds(c.len == a.n, "Submatrix dimensions")
   for i in r.a .. r.b:
      for j in 0 ..< c.len:
         m.data[i][c[j]] = a.data[i - r.a][j]

# Matrix transpose.
proc t*(m: Matrix): Matrix =
   result.m = m.n
   result.n = m.m
   newData()
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result.data[j][i] = m.data[i][j]

# One norm
# returns maximum column sum.
proc norm1*(m: Matrix): float =
   for j in 0 ..< m.n:
      var s = 0.0
      for i in 0 ..< m.m:
         s += abs(m.data[i][j])
      result = max(result, s)

# Two norm
# returns maximum singular value.
# proc norm2*(m: Matrix): float =
#    singularValueDecomposition(m).norm2())

# Infinity norm
# returns maximum row sum.
proc normInf*(m: Matrix): float =
   for i in 0 ..< m.m:
      var s = 0.0
      for j in 0 ..< m.n:
         s += abs(m.data[i][j])
      result = max(result, s)

# Frobenius norm
# returns sqrt of sum of squares of all elements.
proc normF*(m: Matrix): float =
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result = hypot(result, m.data[i][j])

# Unary minus
proc `-`*(m: Matrix): Matrix =
   result.m = m.m
   result.n = m.n
   newData()
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result.data[i][j] = -m.data[i][j]

# C = A + B
proc `+`*(a, b: Matrix): Matrix =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   result.m = a.m
   result.n = a.n
   newData()
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         result.data[i][j] = a.data[i][j] + b.data[i][j]

# A = A + B
proc `+=`*(a: var Matrix, b: Matrix) =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         a.data[i][j] = a.data[i][j] + b.data[i][j]

# C = A - B
proc `-`*(a, b: Matrix): Matrix =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   result.m = a.m
   result.n = a.n
   newData()
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         result.data[i][j] = a.data[i][j] + b.data[i][j]

# A = A - B
proc `-=`*(a: var Matrix, b: Matrix) =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         a.data[i][j] = a.data[i][j] + b.data[i][j]

# Element-by-element multiplication, C = A.*B
proc `.*`*(a, b: Matrix): Matrix =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   result.m = a.m
   result.n = a.n
   newData()
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         result.data[i][j] = a.data[i][j] * b.data[i][j]

# Element-by-element multiplication in place, A = A.*B
proc `.*=`*(a: var Matrix, b: Matrix) =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         a.data[i][j] = a.data[i][j] * b.data[i][j]

# Element-by-element right division, C = A./B
proc `./`*(a, b: Matrix): Matrix =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   result.m = a.m
   result.n = a.n
   newData()
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         result.data[i][j] = a.data[i][j] / b.data[i][j]

# Element-by-element right division in place, A = A./B
proc `./=`*(a: var Matrix, b: Matrix) =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         a.data[i][j] = a.data[i][j] / b.data[i][j]

# Element-by-element left division, C = A.\B
proc `.\`*(a, b: Matrix): Matrix =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   result.m = a.m
   result.n = a.n
   newData()
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         result.data[i][j] = b.data[i][j] / a.data[i][j]

# Element-by-element left division in place, A = A.\B
proc `.\=`*(a: var Matrix, b: Matrix) =
   assert(b.m == a.m and b.n == a.n, "Matrix dimensions must agree.")
   for i in 0 ..< a.m:
      for j in 0 ..< a.n:
         a.data[i][j] = b.data[i][j] / a.data[i][j]

# Multiply a matrix by a scalar, C = s*A
proc `*`*(s: float, m: Matrix): Matrix =
   result.m = m.m
   result.n = m.n
   newData()
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result.data[i][j] = s * m.data[i][j]

# Multiply a matrix by a scalar in place, A = s*A
proc `*=`*(m: var Matrix, s: float) =
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         m.data[i][j] = s * m.data[i][j]

# Linear algebraic matrix multiplication, A * B
proc `*`*(a, b: Matrix): Matrix =
   assert(b.m == a.n, "Matrix inner dimensions must agree.")
   result.m = a.m
   result.n = b.n
   newData()
   var b_colj = newSeq[float](a.n)
   for j in 0 ..< b.n:
      for k in 0 ..< a.n:
         b_colj[k] = b.data[k][j]
      for i in 0 ..< a.m:
         var a_rowi = a.data[i]
         var s = 0.0
         for k in 0 ..< a.n:
            s += a_rowi[k] * b_colj[k]
         result.data[i][j] = s
#[
# LU Decomposition
proc lu(m: Matrix): LUDecomposition =
   LUDecomposition(m)

# QR Decomposition
proc qr(m: Matrix): QRDecomposition =
   QRDecomposition(m)

# Cholesky Decomposition
proc chol(m: Matrix): CholeskyDecomposition =
   CholeskyDecomposition(m)

# Singular Value Decomposition
proc svd(m: Matrix): SingularValueDecomposition =
   SingularValueDecomposition(m)

# Eigenvalue Decomposition
proc eig(m: Matrix): EigenvalueDecomposition =
   EigenvalueDecomposition(m)

# Solve A*X = B
# param B  right hand side
# returns  solution if A is square, least squares solution otherwise
proc solve(a, b: Matrix): Matrix =
   if m == n:
      LUDecomposition(a).solve(b)
   else:
      QRDecomposition(a).solve(b)

# Solve X*A = B, which is also A'*X' = B'
# param B  right hand side
# returns  solution if A is square, least squares solution otherwise.
proc solveTranspose(a, b: Matrix): Matrix =
   t(m).solve(b.t())

# Matrix inverse or pseudoinverse
# returns inverse(A) if A is square, pseudoinverse otherwise.
proc inverse(m: Matrix): Matrix =
   solve(m, identity(m.m, m.m))

# Matrix determinant
proc det(m: Matrix): float =
   LUDecomposition(m).det()

# Matrix rank
# returns  effective numerical rank, obtained from SVD.
proc rank(m: Matrix): int =
   SingularValueDecomposition(m).rank()

# Matrix condition (2 norm)
# returns  ratio of largest to smallest singular value.
proc cond(m: Matrix): float =
   SingularValueDecomposition(m).cond()
]#
# Matrix trace.
# return  sum of the diagonal elements.
proc trace*(m: Matrix): float =
   for i in 0 ..< min(m.m, m.n):
      result += m.data[i][i]

# Generate matrix with random elements
# return  An m-by-n matrix with uniformly distributed random elements.
proc randMatrix*(m, n: int): Matrix =
   result.m = m
   result.n = n
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         result.data[i][j] = rand(1.0)

# Generate identity matrix
# returns An m-by-n matrix with ones on the diagonal and zeros elsewhere.
proc identity*(m, n: int): Matrix =
   result.m = m
   result.n = n
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         if i == j:
            result.data[i][j] = 1.0

# Print the matrix to stdout.   Line the elements up in columns
# with a Fortran-like 'Fw.d' style format.
# param w  Column width.
# param d  Number of digits after the decimal.
proc columnFormat(s: seq[float]): seq[string] =
   result = newSeq[string](s.len)
   for i, v in s:
      result[i] = formatFloat(v, ffDecimal, 6)

   var lenLeft = newSeq[int](s.len)
   var maxLenLeft = 0
   var lenRight = newSeq[int](s.len)
   var maxLenRight = 0

   for i, f in result:
      let index = f.find('.')
      lenLeft[i]  = index
      maxLenLeft = max(maxLenLeft, lenLeft[i])
      lenRight[i] = f.len - index - 1
      maxLenRight = max(maxLenRight, lenRight[i])

   for i in 0 ..< s.len:
      result[i].insert(spaces(maxLenLeft  - lenLeft[i]))
      result[i].add(spaces(maxLenRight - lenRight[i]))

proc `$`*(m: Matrix): string =
   var cols: seq[seq[string]]
   newSeq(cols, m.m)
   for i in 0 ..< m.m:
      cols[i] = columnFormat(m.data[i])

   result = ""
   for j in 0 ..< m.n:
      if j == 0:
         result.add "⎡"
      elif j == m.n - 1:
         result.add "⎣"
      else:
         result.add "⎢"

      for i in 0 ..< m.m:
         if i != 0:
            result.add "  "
         result.add cols[i][j]

      if j == 0:
         result.add "⎤\n"
      elif j == m.n - 1:
         result.add "⎦\n"
      else:
         result.add "⎥\n"
