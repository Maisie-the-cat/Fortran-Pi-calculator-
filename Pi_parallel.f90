!=====================================================================
! pi_parallel.f90
!
! Computes as many digits of Pi as will fit in available RAM using
! the Chudnovsky algorithm with Binary Splitting, parallelized
! across all available CPU cores via OpenMP tasks.
!
! Dependencies: GMP library, OpenMP
!
! Compile:
!   gfortran -fopenmp -O2 -o pi_parallel pi_parallel.f90 -lgmp
!
! Run:
!   OMP_NUM_THREADS=$(nproc) ./pi_parallel          # use all cores
!   OMP_NUM_THREADS=4 ./pi_parallel                 # use 4 threads
!=====================================================================

module gmp_iface
    use, intrinsic :: iso_c_binding
    implicit none

    type, bind(c) :: mpz_t
        integer(c_int) :: mp_alloc
        integer(c_int) :: mp_size
        type(c_ptr)    :: mp_d
    end type

    interface
        subroutine gmp_mpz_init(x) bind(c, name='mpz_init')
            import :: mpz_t
            type(mpz_t), intent(inout) :: x
        end subroutine
        subroutine gmp_mpz_clear(x) bind(c, name='mpz_clear')
            import :: mpz_t
            type(mpz_t), intent(inout) :: x
        end subroutine
        subroutine gmp_mpz_set(rop, op) bind(c, name='mpz_set')
            import :: mpz_t
            type(mpz_t), intent(inout) :: rop
            type(mpz_t), intent(in)    :: op
        end subroutine
        subroutine gmp_mpz_set_ui(rop, op) bind(c, name='mpz_set_ui')
            import :: mpz_t, c_ulong
            type(mpz_t), intent(inout) :: rop
            integer(c_ulong), intent(in), value :: op
        end subroutine
        subroutine gmp_mpz_set_si(rop, op) bind(c, name='mpz_set_si')
            import :: mpz_t, c_long
            type(mpz_t), intent(inout) :: rop
            integer(c_long), intent(in), value :: op
        end subroutine
        subroutine gmp_mpz_add(rop, op1, op2) bind(c, name='mpz_add')
            import :: mpz_t
            type(mpz_t), intent(inout) :: rop
            type(mpz_t), intent(in)    :: op1, op2
        end subroutine
        subroutine gmp_mpz_sub(rop, op1, op2) bind(c, name='mpz_sub')
            import :: mpz_t
            type(mpz_t), intent(inout) :: rop
            type(mpz_t), intent(in)    :: op1, op2
        end subroutine
        subroutine gmp_mpz_mul(rop, op1, op2) bind(c, name='mpz_mul')
            import :: mpz_t
            type(mpz_t), intent(inout) :: rop
            type(mpz_t), intent(in)    :: op1, op2
        end subroutine
        subroutine gmp_mpz_mul_ui(rop, op1, op2) bind(c, name='mpz_mul_ui')
            import :: mpz_t, c_ulong
            type(mpz_t), intent(inout) :: rop
            type(mpz_t), intent(in)    :: op1
            integer(c_ulong), intent(in), value :: op2
        end subroutine
        subroutine gmp_mpz_mul_si(rop, op1, op2) bind(c, name='mpz_mul_si')
            import :: mpz_t, c_long
            type(mpz_t), intent(inout) :: rop
            type(mpz_t), intent(in)    :: op1
            integer(c_long), intent(in), value :: op2
        end subroutine
        subroutine gmp_mpz_addmul(rop, op1, op2) bind(c, name='mpz_addmul')
            import :: mpz_t
            type(mpz_t), intent(inout) :: rop
            type(mpz_t), intent(in)    :: op1, op2
