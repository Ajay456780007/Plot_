function Eval1(s, m)

    if nargin < 2
        m = 'false';  
    end
    % Make Temp folder if not exists
    if ~exist('Temp', 'dir')
        mkdir('Temp');
    end

    if s == 1
        out1 = evalin("base", out.Graph1);
        out2 = evalin("base", out.Graph11);
        a = evalin('base', 'current_model');
        a.out1 = out1;
        a.out2 = out2;

        % Save with removal of .slx if needed
        if strcmp(m, 'true') 
            filename = char(a);
            if endsWith(filename, '.slx')
                filename = filename(1:end-4);
            end
            save(fullfile('Temp', [filename, '.mat']), 'a');
        end

        disp("Saved Results [✔️] for " + a + " ...........");

    elseif s == 2
        out1 = evalin("base", out.Graph2);
        out2 = evalin("base", out.Graph22);
        b = evalin('base', 'current_model');
        b.out1 = out1;
        b.out2 = out2;

        if strcmp(m, 'true') 
            filename = char(b);
            if endsWith(filename, '.slx')
                filename = filename(1:end-4);
            end
            save(fullfile('Temp', [filename, '.mat']), 'b');
        end

        disp("Saved Results [✔️] for " + b + " ...........");

    elseif s == 3
        out1 = evalin("base", out.Graph3);
        out2 = evalin("base", out.Graph33);
        c = evalin('base', 'current_model');
        c.out1 = out1;
        c.out2 = out2;

        if strcmp(m, 'true') 
            filename = char(c);
            if endsWith(filename, '.slx')
                filename = filename(1:end-4);
            end
            save(fullfile('Temp', [filename, '.mat']), 'c');
        end

        disp("Saved Results [✔️] for " + c + " ...........");

    elseif s == 4
        out1 = evalin("base", out.Graph4);
        out2 = evalin("base", out.Graph44);
        d = evalin('base', 'current_model');
        d.out1 = out1;
        d.out2 = out2;

        if strcmp(m, 'true') 
            filename = char(d);
            if endsWith(filename, '.slx')
                filename = filename(1:end-4);
            end
            save(fullfile('Temp', [filename, '.mat']), 'd');
        end

        disp("Saved Results [✔️] for " + d + " ...........");

    elseif s == 5
        out1 = evalin("base", out.Graph5);
        out2 = evalin("base", out.Graph55);
        e = evalin('base', 'current_model');
        e.out1 = out1;
        e.out2 = out2;

        if strcmp(m, 'true') 
            filename = char(e);
            if endsWith(filename, '.slx')
                filename = filename(1:end-4);
            end
            save(fullfile('Temp', [filename, '.mat']), 'e');
        end

        disp("Saved Results [✔️] for " + e + " ...........");

    elseif s == 6
        out1 = evalin("base", out.Graph6);
        out2 = evalin("base", out.Graph66);
        f = evalin('base', 'current_model');
        f.out1 = out1;
        f.out2 = out2;

        if strcmp(m, 'true') 
            filename = char(f);
            if endsWith(filename, '.slx')
                filename = filename(1:end-4);
            end
            save(fullfile('Temp', [filename, '.mat']), 'f');
        end

        disp("Saved Results [✔️] for " + f + " ...........");

    elseif s == 7
        out1 = evalin("base", out.Graph7);
        out2 = evalin("base", out.Graph77);
        g = evalin('base', 'current_model');
        g.out1 = out1;
        g.out2 = out2;

        if strcmp(m, 'true') 
            filename = char(g);
            if endsWith(filename, '.slx')
                filename = filename(1:end-4);
            end
            save(fullfile('Temp', [filename, '.mat']), 'g');
        end

        disp("Saved Results [✔️] for " + g + " ...........");
    else
        disp("Invalid input for s: must be 1 to 7");
    end
end
