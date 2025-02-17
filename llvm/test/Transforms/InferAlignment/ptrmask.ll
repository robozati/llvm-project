; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt < %s -passes=infer-alignment -S | FileCheck %s

target datalayout = "p1:64:64:64:32-p2:64:64:64:128"

; ------------------------------------------------------------------------------
; load instructions
; ------------------------------------------------------------------------------

define void @load(ptr align 1 %ptr) {
; CHECK-LABEL: define void @load
; CHECK-SAME: (ptr align 1 [[PTR:%.*]]) {
; CHECK-NEXT:    [[ALIGNED_0:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR]], i64 -2)
; CHECK-NEXT:    [[ALIGNED_1:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR]], i64 -4)
; CHECK-NEXT:    [[ALIGNED_2:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR]], i64 -8)
; CHECK-NEXT:    [[LOAD_0:%.*]] = load <16 x i8>, ptr [[ALIGNED_0]], align 2
; CHECK-NEXT:    [[LOAD_1:%.*]] = load <16 x i8>, ptr [[ALIGNED_1]], align 4
; CHECK-NEXT:    [[LOAD_2:%.*]] = load <16 x i8>, ptr [[ALIGNED_2]], align 8
; CHECK-NEXT:    ret void
;
  %aligned.0 = call ptr @llvm.ptrmask.p0.i64(ptr %ptr, i64 -2)
  %aligned.1 = call ptr @llvm.ptrmask.p0.i64(ptr %ptr, i64 -4)
  %aligned.2 = call ptr @llvm.ptrmask.p0.i64(ptr %ptr, i64 -8)

  %load.0 = load <16 x i8>, ptr %aligned.0, align 1
  %load.1 = load <16 x i8>, ptr %aligned.1, align 1
  %load.2 = load <16 x i8>, ptr %aligned.2, align 1

  ret void
}

; ------------------------------------------------------------------------------
; store instructions
; ------------------------------------------------------------------------------

define void @store(ptr align 1 %ptr) {
; CHECK-LABEL: define void @store
; CHECK-SAME: (ptr align 1 [[PTR:%.*]]) {
; CHECK-NEXT:    [[ALIGNED_0:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR]], i64 -2)
; CHECK-NEXT:    [[ALIGNED_1:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR]], i64 -4)
; CHECK-NEXT:    [[ALIGNED_2:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR]], i64 -8)
; CHECK-NEXT:    store <16 x i8> zeroinitializer, ptr [[ALIGNED_0]], align 2
; CHECK-NEXT:    store <16 x i8> zeroinitializer, ptr [[ALIGNED_1]], align 4
; CHECK-NEXT:    store <16 x i8> zeroinitializer, ptr [[ALIGNED_2]], align 8
; CHECK-NEXT:    ret void
;
  %aligned.0 = call ptr @llvm.ptrmask.p0.i64(ptr %ptr, i64 -2)
  %aligned.1 = call ptr @llvm.ptrmask.p0.i64(ptr %ptr, i64 -4)
  %aligned.2 = call ptr @llvm.ptrmask.p0.i64(ptr %ptr, i64 -8)

  store <16 x i8> zeroinitializer, ptr %aligned.0, align 1
  store <16 x i8> zeroinitializer, ptr %aligned.1, align 1
  store <16 x i8> zeroinitializer, ptr %aligned.2, align 1

  ret void
}

; ------------------------------------------------------------------------------
; Overaligned pointer
; ------------------------------------------------------------------------------

; Underlying alignment greater than alignment forced by ptrmask
define void @ptrmask_overaligned(ptr align 16 %ptr) {
; CHECK-LABEL: define void @ptrmask_overaligned
; CHECK-SAME: (ptr align 16 [[PTR:%.*]]) {
; CHECK-NEXT:    [[ALIGNED:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR]], i64 -8)
; CHECK-NEXT:    [[LOAD:%.*]] = load <16 x i8>, ptr [[ALIGNED]], align 16
; CHECK-NEXT:    store <16 x i8> zeroinitializer, ptr [[ALIGNED]], align 16
; CHECK-NEXT:    ret void
;
  %aligned = call ptr @llvm.ptrmask.p0.i64(ptr %ptr, i64 -8)

  %load = load <16 x i8>, ptr %aligned, align 1
  store <16 x i8> zeroinitializer, ptr %aligned, align 1

  ret void
}

define i8 @smaller_index_type(ptr addrspace(1) %ptr) {
; CHECK-LABEL: define i8 @smaller_index_type
; CHECK-SAME: (ptr addrspace(1) [[PTR:%.*]]) {
; CHECK-NEXT:    [[PTR2:%.*]] = call ptr addrspace(1) @llvm.ptrmask.p1.i32(ptr addrspace(1) [[PTR]], i32 -4)
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, ptr addrspace(1) [[PTR2]], align 4
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %ptr2 = call ptr addrspace(1) @llvm.ptrmask.p1.i32(ptr addrspace(1) %ptr, i32 -4)
  %load = load i8, ptr addrspace(1) %ptr2, align 1
  ret i8 %load
}

define i8 @larger_index_type(ptr addrspace(2) %ptr) {
; CHECK-LABEL: define i8 @larger_index_type
; CHECK-SAME: (ptr addrspace(2) [[PTR:%.*]]) {
; CHECK-NEXT:    [[PTR2:%.*]] = call ptr addrspace(2) @llvm.ptrmask.p2.i128(ptr addrspace(2) [[PTR]], i128 -4)
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, ptr addrspace(2) [[PTR2]], align 4
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %ptr2 = call ptr addrspace(2) @llvm.ptrmask.p2.i128(ptr addrspace(2) %ptr, i128 -4)
  %load = load i8, ptr addrspace(2) %ptr2, align 1
  ret i8 %load
}

declare ptr @llvm.ptrmask.p0.i64(ptr, i64)
declare ptr addrspace(1) @llvm.ptrmask.p1.i32(ptr addrspace(1), i32)
declare ptr addrspace(2) @llvm.ptrmask.p2.i128(ptr addrspace(2), i128)
