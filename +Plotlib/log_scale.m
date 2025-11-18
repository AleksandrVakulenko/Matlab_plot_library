function log_scale(axis, style, axes_obj)
    arguments
        axis {mustBeMember(axis, ["x", "y", "z", "xy", "xyz"])} = "x"
        style {mustBeMember(style, ["SI", "POW", "auto"])} = "auto"
        axes_obj = gca
    end

    if any(char(axis) == 'x')
        set(axes_obj, 'xscale', 'log');
    end

    if any(char(axis) == 'y')
        set(axes_obj, 'yscale', 'log');
    end

    if any(char(axis) == 'z')
        set(axes_obj, 'zscale', 'log');
    end

    log_scale_ticks(axis, style, axes_obj);

end