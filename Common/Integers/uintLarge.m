classdef uintLarge
	%uintLarge The super class of all uint > 64
	% ONLY SUPPORTS SCALARS!
	
	properties (SetAccess = protected)
		BLOCK;
	end
	
	methods (Access=private)
		
	end
	
	%% Operators
	methods
		%% Addition
		function C = plus(A, B)
			C = A;
			% Allow for regular ints to be used
			if (~isa(B, class(A)))
				D = B;
				B = A;
				for i = length(A.BLOCK):-1:1
					B.BLOCK(i) = 0;
				end
				B.BLOCK(length(A.BLOCK)) = D;
			end
			carry = uint64(0);
			for i = length(A.BLOCK):-1:1
				n = uint64(carry + A.BLOCK(i) + B.BLOCK(i));
				C.BLOCK(i) = uint32(bitand(n, uint64(intmax('uint32'))));
				carry = n / uint64(2^32);
			end
		end
		
		%% Substraction
		function C = minus(A, B)
			C = A + (-B);
		end
		
		%% Unary Minus
		function C = uminus(A)
			C = A;
			for i = length(A.BLOCK):-1:1
				C.BLOCK(i) = uint32(bitxor(A.BLOCK(i), intmax('uint32')));
			end
			C.BLOCK(length(A.BLOCK)) = C.BLOCK(length(A.BLOCK)) + 1;
		end
		
		%% Multiplication
		function C = mtimes(A, B)
			C = A;
			for i = 2:1:B
				C = C + A;
			end
		end
		
		%% Division
		function C = mrdivide(A, B)
			C = A - A;
			% Allow for regular ints to be used
			if (~isa(B, class(A)))
				D = B;
				B = A;
				for i = length(A.BLOCK):-1:1
					B.BLOCK(i) = 0;
				end
				B.BLOCK(length(A.BLOCK)) = D;
			end
			while (A >= B)
				A = A - B;
				C = C + 1;
			end
		end
		
		%% Greater Than
		function C = gt(A, B)
			for i = length(A.BLOCK):-1:1
				if (A.BLOCK(i) > B.BLOCK(i))
					C = 1;
					return;
				elseif (A.BLOCK(i) < B.BLOCK(i))
					C = 0;
					return;
				end
			end
			C = 0;
		end
		
		%% Greater Or Equal Than
		function C = ge(A, B)
			for i = length(A.BLOCK):-1:1
				if (A.BLOCK(i) < B.BLOCK(i))
					C = 0;
					return;
				else
					C = 1;
					return;
				end
			end
		end
		
		%% Less Than
		function C = lt(A, B)
			for i = length(A.BLOCK):-1:1
				if (A.BLOCK(i) < B.BLOCK(i))
					C = 1;
					return;
				elseif (A.BLOCK(i) > B.BLOCK(i))
					C = 0;
					return;
				end
			end
			C = 0;
		end
		
		%% Less Or Equal Than
		function C = le(A, B)
			for i = length(A.BLOCK):-1:1
				if (A.BLOCK(i) > B.BLOCK(i))
					C = 0;
					return;
				else
					C = 1;
					return;
				end
			end
		end
		
		%% Display
		
	end
	
end