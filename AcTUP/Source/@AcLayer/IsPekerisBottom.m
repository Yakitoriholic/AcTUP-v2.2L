function IsPek = IsPekerisBottom(Layer)
%Checks to see whether the specified layer is a bottom layer suitable for a Pekeris environment
%(infinite acoustic halfspace)

IsPek =  ...
   Layer.IsHalfSpace & ...
   (length(Layer.Z) == 1) & ...
   isempty(find(Layer.Cs ~= 0)) & ...
   isempty(find(Layer.Ap ~= 0)) & ...      
   isempty(find(Layer.As ~= 0)); 
