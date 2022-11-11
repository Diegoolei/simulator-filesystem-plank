-- 1) a)

{-
Example:
f :: (a,b) -> X

f (a,b) = ...

It’s well typed. Subexpresions
•(a,b) :: (a,b)
•a :: a
•b :: b
The pattern covers every possible type
-}

{-
f :: (a,b) -> X
f x = ...

It’s well typed. Subexpresions
•x :: (a,b)
The pattern does not cover every possible type
-}

{-
f :: (a,b) -> X
f (x,y) = ...

It’s well typed. Subexpresions
•(x,y) :: (a,b)
•x :: a
•y :: b
The pattern does not cover every possible type
-}

{-
f :: [(a,b)] -> X
f (a,b) = ...

It’s not well typed. 
-}

{-
f :: [(a,b)] -> X
f (x:xs) = ...

It’s well typed. Subexpresions
•(x:xs) :: [(a,b)]
•x :: (a,b)
•xs :: [(a,b)]
The pattern does not cover every possible type
-}

{-
f :: [(a,b)] -> X
f ((x,y):((a,b):xs)) = ...

It’s well typed. Subexpresions
•((x,y):((a,b):xs)) :: [(a,b)]
•(x, y) :: (a,b)
•x :: a
•y :: b
•((a,b):xs) :: [(a,b)]
•(a,b) :: (a,b)
•a :: a
•b :: b
•xs :: [(a,b)]
The pattern covers every possible type
-}

{-
f :: [(Int,a)] -> X
f [(0,a)] = ...

It’s well typed. Subexpresions
•[(0,a)] :: [(Int,a)]
•0 :: Int
•a :: a
The pattern covers every possible type
-}

{-
f :: [(Int,a)] -> X
f ((x,1):xs) = ...

It’s well typed. Subexpresions
•((x,1):xs) :: [(Int,a)]
•(x,1) :: (Int,a)
•x :: Int
•1 :: Int
•a :: Int
•xs :: [(Int,a)]
The pattern covers every possible type
-}

{-
f :: [(Int,a)] -> X
f ((1,x):xs) = ...

It’s well typed. Subexpresions
•((1,x):xs) :: [(Int,a)]
•(1,x) :: (Int,a)
•x :: a
•1 :: Int
•xs :: [(Int,a)]
The pattern covers every possible type
-}

{-
f :: (Int -> Int) -> Int -> X
f a b = ...

It’s well typed. Subexpresions
•a :: Int -> Int
•b :: Int
The pattern does not cover every possible type
-}

{-
f :: (Int -> Int) -> Int -> X
f a 3 = ...

It’s well typed. Subexpresions
•a :: Int -> Int
•3 :: Int
The pattern does not cover every possible type
-}

{-
f :: (Int -> Int) -> Int -> X
f 0 1 2 = ...

It’s no well typed
-}

{-
f :: Int -> Int -> Int -> X
f 0 1 2 = ...

It’s well typed. Subexpresions
•0 :: Int
•1 :: Int
•2 :: Int
The pattern covers every possible type
-}

{-
f :: Int -> Int -> Int -> X
f 0 g = ...

It’s not well typed
-}

{-
f :: a -> (a -> a) -> X
f 0 g = ...
It’s well typed. Subexpresions
•0 :: a
•g :: a -> a
The pattern does not cover every possible type
-}

-- 1) b)
snd' :: (a,b) -> b
snd' (_,y) =  y
-- There exists another different definition? No

plank :: a -> b
plank x = x == plank
-- There exists another different definition? yes

-- f :: (a,b) -> c non definable

apply_function :: (a -> b) -> a -> b
apply_function f x = f x
-- There exists another different definition? no

-- f :: (a -> b) -> a -> c non definable

list_funct :: (a -> b) -> [a] -> [b]
list_funct f x = map f x
-- There exists another different definition? no

_(-.) :: (a -> b) -> (b -> c) -> a -> c
_(-.) = (<&>)

-- There exists another different definition? no

transitivity :: (a -> b) -> (b -> c) -> [a] -> [c]
transitivity f g x = map (g . f) x
-- There exists another different definition? no


-- 2)
optimizeList :: Eq a => [ a ] -> [ (Int, a) ]
optimizeList [] = []
optimizeList (x:xs) = (1 + length (takeWhile (==x) xs), x) : optimizeList (dropWhile (==x) xs)

-- 3)

data Tree = Leaf Int | Node Tree Tree
