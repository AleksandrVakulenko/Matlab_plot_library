
% FIXME: this is demo version of shaded errorbar plot.
% Will be replaced by Plot_lib/unsorted/errorbar_sh_full/
% with extended args list (x, y, err, err_pos, Linespec, opts)

function obj = errorbarShaded(x, y, y_err, Linespec)
arguments
    x
    y
    y_err
    Linespec
end

obj = shadedErrorBar(x, y, y_err, 'lineprop', Linespec);


end