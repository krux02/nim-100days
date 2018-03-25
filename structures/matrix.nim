
template checkBounds(cond: untyped, msg = "") =
   when compileOption("boundChecks"):
      {.line.}:
         if not cond:
            raise newException(IndexError, msg)

template newData() =
   newSeq(result.data, result.m)
   for i in 0 ..< result.m:
      newSeq(result.data[i], result.n)

type Matrix = object
   # Array for internal storage of elements.
   data: seq[seq[float]]
   # Row and column dimensions.
   m, n: int

# Construct an m-by-n matrix of zeros. 
proc matrix(m, n: int): Matrix =
   result.m = m
   result.n = n
   newData()

# Construct an m-by-n constant matrix.
proc matrix(m, n: int, s: float): Matrix =
   result.m = m
   result.n = n
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         result.data[i][j] = s

# Construct a matrix from a 2-D array.
proc matrix(data: seq[seq[float]]): Matrix =
   result.m = data.len
   result.n = data[0].len
   result.data = data

# Construct a matrix from a one-dimensional packed array
# data One-dimensional array of float, packed by columns (ala Fortran).
# Array length must be a multiple of m.
proc matrix(data: seq[float], m: int): Matrix =
   result.m = m
   result.n = if m != 0: data.len div m else: 0
   assert result.m * result.n == data.len, "Array length must be a multiple of m."
   newData()
   for i in 0 ..< m:
      for j in 0 ..< result.n:
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
proc `[]`(m: Matrix, r, c: Slice[int]): Matrix =
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
proc `[]`(m: Matrix, r, c: openarray[int]): Matrix =
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
proc `[]`(m: Matrix, r: Slice[int], c: openarray[int]): Matrix =
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
proc `[]`(m: Matrix, r: openarray[int], c: Slice[int]): Matrix =
   checkBounds(r.len <= m.m, "Submatrix dimensions")
   checkBounds(c.a >= 0 and c.b < m.n, "Submatrix dimensions")
   result.m = r.len
   result.n = c.b - c.a + 1
   newData()
   for i in 0 ..< r.len:
      for j in c.a .. c.b:
         result.data[i][j - c.a] = m.data[r[i]][j]

# Set a single element.
proc `[]=`(m: var Matrix, i, j: int, s: float) =
   m.data[i][j] = s

# Set a submatrix.
#   m[i0 .. i1, j0 .. j1] = a
proc `[]=`(m: var Matrix, r, c: Slice[int], a: Matrix) =
   checkBounds(r.b - r.a + 1 == a.m, "Submatrix dimensions")
   checkBounds(c.b - c.a + 1 == a.n, "Submatrix dimensions")
   for i in r.a .. r.b:
      for j in c.a .. c.b:
         m.data[i][j] = a.data[i - r.a][j - c.a]

# Set a submatrix.
proc `[]=`(m: var Matrix, r, c: openarray[int], a: Matrix) =
   checkBounds(r.len == a.m, "Submatrix dimensions")
   checkBounds(c.len == a.n, "Submatrix dimensions")
   for i in 0 ..< r.len:
      for j in 0 ..< c.len:
         m.data[r[i]][c[j]] = a.data[i][j]

# Set a submatrix.
#   m[[0, 2, 3, 4], j0 .. j1] = a
proc `[]=`(m: var Matrix, r: openarray[int], c: Slice[int], a: Matrix) =
   checkBounds(r.len == a.m, "Submatrix dimensions")
   checkBounds(c.b - c.a + 1 == a.n, "Submatrix dimensions")
   for i in 0 ..< r.len:
      for j in c.a .. c.b:
         m.data[r[i]][j] = a.data[i][j - c.a]

# Set a submatrix.
#   m[i0 .. i1, [0, 2, 3, 4]] = a
proc `[]=`(m: var Matrix, r: Slice[int], c: openarray[int], a: Matrix) =
   checkBounds(r.b - r.a + 1 == a.m, "Submatrix dimensions")
   checkBounds(c.len == a.n, "Submatrix dimensions")
   for i in r.a .. r.b:
      for j in 0 ..< c.len:
         m.data[i][c[j]] = a.data[i - r.a][j]

when isMainModule:
   let m = matrix(@[
      @[1.0, 3.0],
      @[2.0, 8.0],
      @[-2.0, 3.0]])

   echo m[[1], 0 .. 1]
