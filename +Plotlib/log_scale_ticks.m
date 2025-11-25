
function log_scale_ticks(axis, style, axes_obj)
    arguments
        axis {mustBeMember(axis, ["x", "y", "z", "xy", "xyz"])} = "x"
        style {mustBeMember(style, ["SI", "POW", "auto"])} = "auto"
        axes_obj = gca
    end

    switch axis
        case {"x", "y", "z"}
            set_axis_ticks(axes_obj, style, axis);
        case "xy"
            set_axis_ticks(axes_obj, style, "x");
            set_axis_ticks(axes_obj, style, "y");

        case "xyz"
            set_axis_ticks(axes_obj, style, "x");
            set_axis_ticks(axes_obj, style, "y");
            set_axis_ticks(axes_obj, style, "z");
    end
end




function set_axis_ticks(ax_frame, style, ax)
    arguments
        ax_frame
        style {mustBeMember(style, ["SI", "POW", "auto"])} = "auto"
        ax {mustBeMember(ax, ["x", "y", "z"])} = "y"
    end
    ax = char(ax);
    
    Scale = get(ax_frame, [ax 'scale']);
    if Scale ~= "log"
        return
    end
    
    Llim = get(ax_frame, [ax 'lim']);
    Min = Llim(1);
    Max = Llim(2);
    
    switch style
        case "SI"
            Grid = [1 2 5];
            Ticks = gen_log_tick([Min Max], Grid);
            if numel(Ticks) > 12
                Grid = [1 3];
                Ticks = gen_log_tick([Min Max], Grid);
                if numel(Ticks) > 12
                    Grid = [1];
                    Ticks = gen_log_tick([Min Max], Grid);
                end
            end
    
        case "POW"
            Grid = [1];
            Ticks = gen_log_tick([Min Max], Grid);
    
        case "auto"
            N = log10(Max/Min);
            if N < 4
                Grid = [1 2 5];
                Ticks = gen_log_tick([Min Max], Grid);
                style = "SI";
            else
                Grid = [1];
                Ticks = gen_log_tick([Min Max], Grid);
                style = "POW";
            end
    
    end
    
    
    switch style
        case "SI"
            Tick_label = get_ticks_label_SI(Ticks);
        case "POW"
            Tick_label = get_ticks_label_POW(Ticks);
    end
    
    set(ax_frame, [ax 'tick'], Ticks);
    set(ax_frame, [ax 'ticklabel'], Tick_label);
end




function Ticks = gen_log_tick(Range, Grid)
    arguments
        Range {mustBeNumeric(Range)}
        Grid {mustBeNumeric(Grid)} = [1, 2, 5]
    end
    
    Min = Range(1);
    Max = Range(2);
    if Min > Max
        tmp = Min;
        Min = Max;
        Max = tmp;
        warning('swap min and max')
    elseif Min == Max
        error('Range(1) must be < Range(2)')
    end
    
    Exp_start = floor(log10(Min));
    Exp_end = ceil(log10(Max));
    Exp_range = Exp_start:Exp_end;
    
    Ticks = zeros(1, numel(Grid)*numel(Exp_range));
    k = 0;
    for i = Exp_range
        for j = 1:numel(Grid)
            k = k + 1;
            Ticks(k) = Grid(j)*10^i;
        end
    end
    Ticks(Ticks < Min) = [];
    Ticks(Ticks > Max) = [];
end




function Tick_label = get_ticks_label_SI(Ticks)
    
    Tick_label = string.empty;
    for i = 1:numel(Ticks)
        Num = digits_count(Ticks(i), -inf);
    %     disp([num2str(Ticks(i), '%0.9f') ' ' num2str(Num)])
        if Num < 0
            Exp = fix(Num/3)*3;
        else
            Exp = ceil(Num/3)*3;
        end
    
        [Exp, Unit] = get_exp_unit(Exp);
    
        Tick_label(i) = sprintf("%d%s", round(Ticks(i)*10^Exp), Unit);
    end
end
    



function [Exp, Unit] = get_exp_unit(Exp)
    if Exp > 18
        Exp = 18;
    end
    if Exp < -12
        Exp = -12;
    end
    switch Exp
        case 18
            Unit = "a";
        case 15
            Unit = "f";
        case 12
            Unit = "p";
        case 9
            Unit = "n";
        case 6
            Unit = "u";
        case 3
            Unit = "m";
        case 0
            Unit = "";
        case -3
            Unit = "k";
        case -6
            Unit = "M";
        case -9
            Unit = "G";
        case -12
            Unit = "T";
        otherwise
            error('placeholder')
    end
end




function Tick_label = get_ticks_label_POW(Ticks)

Tick_label = string.empty;
for i = 1:numel(Ticks)
    Num = digits_count(Ticks(i), -inf);
    if Num < 0
        Exp = fix(Num/3)*3;
    else
        Exp = ceil(Num/3)*3;
    end
    
    Exp = log10(Ticks(i));

    if is_int_num(Exp)
        if Exp ~= 0
            Tick_label(i) = sprintf("%d^{%d}", 10, Exp);
        else
            Tick_label(i) = sprintf("%d^{ }", Ticks(i));
        end
    else
        Tick_label(i) = "";
    end
end
end


function status = is_int_num(num)
    status = round(num) == num;
end

function [n, fmt] = digits_count(a, min_n)
    arguments
        a (1,1) {mustBeNumeric(a)}
        min_n (1,1) {mustBeNumeric(min_n)} = 0
    end
    
    what_is_number_six = 6; % FIXME ???

    n = -floor(log10(a));
    while (a*10^n - round(a*10^n) ~= 0) && n < what_is_number_six
        n = n + 1;
    end

    if n < min_n
        n = min_n;
    end

    fmt = ['%.' num2str(n) 'f'];
end