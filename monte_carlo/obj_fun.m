function score = obj_fun(x)
    % x is a structure with fields: tau, Lp, Lv
    score = monte(x.tau, x.Lp, x.Lv);
end

