; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 5
; RUN: opt -S --passes=slp-vectorizer -mtriple=riscv64-unknown-linux-gnu -mattr=+v -slp-threshold=-1000 %s | FileCheck %s

define void @test(ptr %mdct_forward_x) {
; CHECK-LABEL: define void @test(
; CHECK-SAME: ptr [[MDCT_FORWARD_X:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  [[ENTRY:.*:]]
; CHECK-NEXT:    br label %[[FOR_COND:.*]]
; CHECK:       [[FOR_COND]]:
; CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[MDCT_FORWARD_X]], align 8
; CHECK-NEXT:    [[ARRAYIDX2_I_I:%.*]] = getelementptr i8, ptr [[TMP0]], i64 32
; CHECK-NEXT:    [[ARRAYIDX5_I_I:%.*]] = getelementptr i8, ptr [[TMP0]], i64 40
; CHECK-NEXT:    [[ADD_PTR_I:%.*]] = getelementptr i8, ptr [[TMP0]], i64 24
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x ptr> poison, ptr [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x ptr> [[TMP1]], <4 x ptr> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <4 x ptr> [[TMP2]], <4 x i64> <i64 28, i64 36, i64 24, i64 28>
; CHECK-NEXT:    [[TMP5:%.*]] = call <3 x float> @llvm.masked.load.v3f32.p0(ptr [[ADD_PTR_I]], i32 4, <3 x i1> <i1 true, i1 false, i1 true>, <3 x float> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <3 x float> [[TMP5]], <3 x float> poison, <2 x i32> <i32 2, i32 0>
; CHECK-NEXT:    [[TMP6:%.*]] = call <3 x float> @llvm.masked.load.v3f32.p0(ptr [[ARRAYIDX5_I_I]], i32 4, <3 x i1> <i1 true, i1 false, i1 true>, <3 x float> poison)
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <3 x float> [[TMP6]], <3 x float> poison, <2 x i32> <i32 2, i32 0>
; CHECK-NEXT:    [[TMP8:%.*]] = call <4 x float> @llvm.masked.gather.v4f32.v4p0(<4 x ptr> [[TMP3]], i32 4, <4 x i1> splat (i1 true), <4 x float> poison)
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <3 x float> [[TMP6]], <3 x float> poison, <4 x i32> <i32 2, i32 0, i32 2, i32 2>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <2 x float> [[TMP4]], <2 x float> poison, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <3 x float> [[TMP5]], <3 x float> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 poison>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x float> <float poison, float poison, float 0.000000e+00, float poison>, <4 x float> [[TMP22]], <4 x i32> <i32 poison, i32 poison, i32 2, i32 6>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x float> [[TMP11]], <4 x float> [[TMP10]], <4 x i32> <i32 4, i32 5, i32 2, i32 3>
; CHECK-NEXT:    [[TMP13:%.*]] = fsub <4 x float> [[TMP9]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = fadd <4 x float> [[TMP9]], [[TMP12]]
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <4 x float> [[TMP13]], <4 x float> [[TMP14]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[TMP16:%.*]] = fsub <4 x float> zeroinitializer, [[TMP8]]
; CHECK-NEXT:    [[TMP17:%.*]] = fadd <4 x float> zeroinitializer, [[TMP8]]
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <4 x float> [[TMP16]], <4 x float> [[TMP17]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    store float 0.000000e+00, ptr [[ADD_PTR_I]], align 4
; CHECK-NEXT:    [[TMP19:%.*]] = fsub <4 x float> [[TMP15]], [[TMP18]]
; CHECK-NEXT:    [[TMP20:%.*]] = fadd <4 x float> [[TMP15]], [[TMP18]]
; CHECK-NEXT:    [[TMP21:%.*]] = shufflevector <4 x float> [[TMP19]], <4 x float> [[TMP20]], <4 x i32> <i32 0, i32 5, i32 2, i32 3>
; CHECK-NEXT:    store <4 x float> [[TMP21]], ptr [[ARRAYIDX2_I_I]], align 4
; CHECK-NEXT:    br label %[[FOR_COND]]
;
entry:
  br label %for.cond

for.cond:
  %0 = load ptr, ptr %mdct_forward_x, align 8
  %add.ptr.i = getelementptr i8, ptr %0, i64 24
  %arrayidx.i.i = getelementptr i8, ptr %0, i64 48
  %1 = load float, ptr %arrayidx.i.i, align 4
  %add.i.i = fadd float %1, 0.000000e+00
  %arrayidx2.i.i = getelementptr i8, ptr %0, i64 32
  %2 = load float, ptr %arrayidx2.i.i, align 4
  %sub.i.i = fsub float %1, %2
  %3 = load float, ptr %add.ptr.i, align 4
  %add4.i.i = fadd float %3, 0.000000e+00
  %arrayidx5.i.i = getelementptr i8, ptr %0, i64 40
  %4 = load float, ptr %arrayidx5.i.i, align 4
  %sub7.i.i = fsub float %4, %3
  %sub8.i.i = fsub float %add.i.i, %add4.i.i
  store float %sub8.i.i, ptr %arrayidx5.i.i, align 4
  %arrayidx10.i.i = getelementptr i8, ptr %0, i64 28
  %5 = load float, ptr %arrayidx10.i.i, align 4
  %sub11.i.i = fsub float 0.000000e+00, %5
  %arrayidx12.i.i = getelementptr i8, ptr %0, i64 36
  %6 = load float, ptr %arrayidx12.i.i, align 4
  %sub13.i.i = fsub float 0.000000e+00, %6
  store float 0.000000e+00, ptr %add.ptr.i, align 4
  %sub15.i.i = fsub float %sub.i.i, %sub11.i.i
  store float %sub15.i.i, ptr %arrayidx2.i.i, align 4
  %add17.i.i = fadd float %sub7.i.i, %sub13.i.i
  store float %add17.i.i, ptr %arrayidx12.i.i, align 4
  %arrayidx20.i.i = getelementptr i8, ptr %0, i64 44
  store float %sub15.i.i, ptr %arrayidx20.i.i, align 4
  br label %for.cond
}
