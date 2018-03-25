
type
   Array[n: static[int]] = array[n, float]
   DoubleArray[m, n: static[int]] = array[m, array[n, float]]

template newData =
   newSeq(result.data, result.m)
   for i in 0 ..< result.m:
      newSeq(result.data[i], result.n)

type Matrix = object
   # Array for internal storage of elements.
   data: seq[seq[float]]
   # Row and column dimensions.
   m, n: int

# Construct an m-by-n matrix of zeros. 
proc newMatrix(m, n: int): Matrix =
   result.m = m
   result.n = n
   newData()

# Construct an m-by-n constant matrix.
proc newMatrix(m, n: int, s: float): Matrix =
   result.m = m
   result.n = n
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         result.data[i][j] = s

# Construct a matrix from a 2-D array.
proc newMatrix(data: DoubleArray): Matrix =
   result.m = data.len
   result.n = data[0].len
   result.data = data

# Construct a matrix from a one-dimensional packed array
# data One-dimensional array of float, packed by columns (ala Fortran).
# Array length must be a multiple of m.
proc newMatrix(data: Array, m: int): Matrix =
   result.m = m
   result.n = if m != 0: data.len div m else: 0
   assert result.m * result.n == data.len, "Array length must be a multiple of m."
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         result.data[i][j] = data[i + j * m]

# Copy the internal two-dimensional array.
proc getArray(m: Matrix): seq[seq[float]] =
   result = m.data

# Make a one-dimensional column packed copy of the internal array.
proc getColumnPacked(m: Matrix): seq[float] =
   newSeq(result, m.m * m.n)
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result[i + j * m.m] = m.data[i][j]

# Make a one-dimensional row packed copy of the internal array.
proc getRowPacked(m: Matrix): seq[float] =
   newSeq(result, m.m * m.n)
   for i in 0 ..< m.m:
      for j in 0 ..< m.n:
         result[i * m.n + j] = m.data[i][j]

# Get row dimension.
proc rowDimension(m: Matrix): int =
   m.m

# Get column dimension.
proc columnDimension(m: Matrix): int =
   m.n

# Get a single element.
proc `[]`(m: Matrix, i, j: int): float =
   m.data[i][j]

# Get a submatrix.
#   m[i0 .. i1, j0 .. j1]
proc `[]`(m: Matrix, i0, i1, j0, j1: int): Matrix =
   result.m = i1 - i0 + 1
   result.n = j1 - j0 + 1
   assert result.m > 0 and result.n > 0, "Submatrix dimensions"
   newData()
   for i in i0 .. i1:
      for j in j0 .. j1:
         result.data[i - i0][j - j0] = m.data[i][j]

# Get a submatrix.
#   m[[0, 2, 3, 4], [1, 2, 3, 4]]
proc `[]`(m: Matrix, r, c: seq[int]): Matrix =
   result.m = r.len
   result.n = c.len
   assert result.m > 0 and result.n > 0, "Submatrix dimensions"
   newData()
   for i in 0 ..< r.len:
      for j in 0 ..< c.len:
         result.data[i][j] = m.data[r[i]][c[j]]

# Get a submatrix.
#   m[i0 .. i1, [0, 2, 3, 4]]
proc `[]`(m: Matrix, i0, i1: int, c: seq[int]): Matrix =
   result.m = i1 - i0 + 1
   result.n = c.len
   assert result.m > 0 and result.n > 0, "Submatrix dimensions"
   newData()
   for i in i0 .. i1:
      for j in 0 ..< c.len:
         result.data[i - i0][j] = m.data[i][c[j]]

# Get a submatrix.
#   m[[0, 2, 3, 4], j0 .. j1]
proc `[]`(m: Matrix, r: seq[int], j0, j1: int): Matrix =
   result.m = r.len
   result.n = j1 - j0 + 1
   assert result.m > 0 and result.n > 0, "Submatrix dimensions"
   newData()
   for i in 0 ..< r.len:
      for j in j0 .. j1:
         result.data[i][j - j0] = m.data[r[i]][j]

# Set a single element.
proc `[]=`(m: var Matrix, i, j: int, s: float) =
   m.data[i][j] = s

# Set a submatrix.
#   m[i0 .. i1, j0 .. j1] = a
proc `[]=`(m: var Matrix, i0, i1, j0, j1: int, a: Matrix) =
   assert i1 - i0 + 1 == a.m and j1 - j0 + 1 == a.n, "Submatrix dimensions"
   for i in i0 .. i1:
      for j in j0 .. j1:
         m.data[i][j] = a.data[i - i0][j - j0]

# Set a submatrix.
proc `[]=`(m: var Matrix, r, c: seq[int], a: Matrix) =
   assert r.len == a.m and c.len == a.n, "Submatrix dimensions"
   for i in 0 ..< r.len:
      for j in 0 ..< c.len:
         m.data[r[i]][c[j]] = a.data[i][j]

# Set a submatrix.
#   m[[0, 2, 3, 4], j0 .. j1] = a
proc `[]=`(m: var Matrix, r: seq[int], j0, j1: int, a: Matrix) =
   assert r.len == a.m and j1 - j0 + 1 == a.n, "Submatrix dimensions"
   for i in 0 ..< r.len:
      for j in j0 .. j1:
         m.data[r[i]][j] = a.data[i][j - j0]

# Set a submatrix.
#   m[i0 .. i1, [0, 2, 3, 4]] = a
proc `[]=`(m: var Matrix, i0, i1: int, c: seq[int], a: Matrix) =
   assert i1 - i0 + 1 == a.m and c.len == a.n, "Submatrix dimensions"
   for i in i0 .. i1:
      for j in 0 ..< c.len:
         m.data[i][c[j]] = a.data[i - i0][j]
