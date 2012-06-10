{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, FunctionalDependencies #-}

module Control.OperationalTransformation
  ( OTOperation (..)
  , OTComposableOperation (..)
  , OTSystem (..)
  ) where

class OTOperation op where
  transform :: op -> op -> Maybe (op, op)

class (OTOperation op) => OTComposableOperation op where
  compose :: op -> op -> Maybe op

class (OTOperation op) => OTSystem doc op where
  apply :: op -> doc -> Maybe doc

data OpList op = SingleOp op
               | ConsecutiveOps op (OpList op)
               deriving (Show, Read, Eq)

instance (OTOperation op) => OTOperation (OpList op) where
  transform = transformList2
    where
      transformList1 o (SingleOp p) = do
        (o', p') <- transform o p
        return (o', SingleOp p')
      transformList1 o (ConsecutiveOps p ps) = do
        (o', p') <- transform o p
        (o'', ps') <- transformList1 o' ps
        return (o'', ConsecutiveOps p' ps')

      transformList2 (SingleOp o) ps = do
        (o', ps') <- transformList1 o ps
        return (SingleOp o', ps')
      transformList2 (ConsecutiveOps o os) ps = do
        (o', ps') <- transformList1 o ps
        (os', ps'') <- transformList2 os ps'
        return (ConsecutiveOps o' os', ps'')

instance (OTOperation op) => OTComposableOperation (OpList op) where
  compose a b = Just $ loop a b
    where
      loop (SingleOp op) ops = ConsecutiveOps op ops
      loop (ConsecutiveOps op ops) ops2 = ConsecutiveOps op $ loop ops ops2

instance (OTSystem doc op) => OTSystem doc (OpList op) where
  apply (SingleOp op) doc = apply op doc
  apply (ConsecutiveOps op ops) doc = apply op doc >>= apply ops


instance (OTOperation a, OTOperation b) => OTOperation (a, b) where
  transform (a1, a2) (b1, b2) = do
    (a1', b1') <- transform a1 b1
    (a2', b2') <- transform a2 b2
    return ((a1', a2'), (b1', b2'))

instance (OTComposableOperation a, OTComposableOperation b) => OTComposableOperation (a, b) where
  compose (a1, a2) (b1, b2) = do
    c1 <- compose a1 b1
    c2 <- compose a2 b2
    return (c1, c2)

instance (OTSystem doca a, OTSystem docb b) => OTSystem (doca, docb) (a, b) where
  apply (a, b) (doca, docb) = do
    doca' <- apply a doca
    docb' <- apply b docb
    return (doca', docb')


instance (OTOperation a, OTOperation b, OTOperation c) => OTOperation (a, b, c) where
  transform (a1, a2, a3) (b1, b2, b3) = do
    (a1', b1') <- transform a1 b1
    (a2', b2') <- transform a2 b2
    (a3', b3') <- transform a3 b3
    return ((a1', a2', a3'), (b1', b2', b3'))

instance (OTComposableOperation a, OTComposableOperation b, OTComposableOperation c) => OTComposableOperation (a, b, c) where
  compose (a1, a2, a3) (b1, b2, b3) = do
    c1 <- compose a1 b1
    c2 <- compose a2 b2
    c3 <- compose a3 b3
    return (c1, c2, c3)

instance (OTSystem doca a, OTSystem docb b, OTSystem docc c) => OTSystem (doca, docb, docc) (a, b, c) where
  apply (a, b, c) (doca, docb, docc) = do
    doca' <- apply a doca
    docb' <- apply b docb
    docc' <- apply c docc
    return (doca', docb', docc')


instance (OTOperation a, OTOperation b, OTOperation c, OTOperation d) => OTOperation (a, b, c, d) where
  transform (a1, a2, a3, a4) (b1, b2, b3, b4) = do
    (a1', b1') <- transform a1 b1
    (a2', b2') <- transform a2 b2
    (a3', b3') <- transform a3 b3
    (a4', b4') <- transform a4 b4
    return ((a1', a2', a3', a4'), (b1', b2', b3', b4'))

instance (OTComposableOperation a, OTComposableOperation b, OTComposableOperation c, OTComposableOperation d) => OTComposableOperation (a, b, c, d) where
  compose (a1, a2, a3, a4) (b1, b2, b3, b4) = do
    c1 <- compose a1 b1
    c2 <- compose a2 b2
    c3 <- compose a3 b3
    c4 <- compose a4 b4
    return (c1, c2, c3, c4)

instance (OTSystem doca a, OTSystem docb b, OTSystem docc c, OTSystem docd d) => OTSystem (doca, docb, docc, docd) (a, b, c, d) where
  apply (a, b, c, d) (doca, docb, docc, docd) = do
    doca' <- apply a doca
    docb' <- apply b docb
    docc' <- apply c docc
    docd' <- apply d docd
    return (doca', docb', docc', docd')


instance (OTOperation a, OTOperation b, OTOperation c, OTOperation d, OTOperation e) => OTOperation (a, b, c, d, e) where
  transform (a1, a2, a3, a4, a5) (b1, b2, b3, b4, b5) = do
    (a1', b1') <- transform a1 b1
    (a2', b2') <- transform a2 b2
    (a3', b3') <- transform a3 b3
    (a4', b4') <- transform a4 b4
    (a5', b5') <- transform a5 b5
    return ((a1', a2', a3', a4', a5'), (b1', b2', b3', b4', b5'))

instance (OTComposableOperation a, OTComposableOperation b, OTComposableOperation c, OTComposableOperation d, OTComposableOperation e) => OTComposableOperation (a, b, c, d, e) where
  compose (a1, a2, a3, a4, a5) (b1, b2, b3, b4, b5) = do
    c1 <- compose a1 b1
    c2 <- compose a2 b2
    c3 <- compose a3 b3
    c4 <- compose a4 b4
    c5 <- compose a5 b5
    return (c1, c2, c3, c4, c5)

instance (OTSystem doca a, OTSystem docb b, OTSystem docc c, OTSystem docd d, OTSystem doce e) => OTSystem (doca, docb, docc, docd, doce) (a, b, c, d, e) where
  apply (a, b, c, d, e) (doca, docb, docc, docd, doce) = do
    doca' <- apply a doca
    docb' <- apply b docb
    docc' <- apply c docc
    docd' <- apply d docd
    doce' <- apply e doce
    return (doca', docb', docc', docd', doce')