function Plot(showPlots, savePlots)
    % showPlots - logical, true to display figures, false to hide
    % savePlots - logical, true to save images, false not to save

    models = cell(1,7);
    for i = 1:7
        data = load(sprintf('Model%d.mat',i));
        models{i} = data.Model1;
    end

    out1_vars = {'Load_current','Load_Voltage','Input_Voltage','Input_Current'};
    out2_vars = {'Injected_Voltage','Power_Factor','Recative_Power','Apparent_Power','Injected_Current'};

    % For CSV data collection
    % Each CSV file will be saved in Results/<Variable>/Data.csv
    % Columns: Time, Model1, Model2, ..., Model7

    % Plotting out1 variables first
    % Arrange three plots:
    % 1: 3 subplots (first 3 variables)
    % 2: 2 subplots (last variable shows leftover 1 in out1_vars (actually 4 vars, so 3+1+leftover)
    % Since 4 vars: do 3 plot sets: (3 | 1 | none), but user said "3 plots it like three in first plot like subplot"
    % Then for next variable, do similarly, so for 4 variables: plot each variable over 7 models
    % Actually, user wants per variable plot across models arranged by subplots across images
    % So we plot for each variable a figure with subplots pooling the 7 models:
    %   (hold on in one plot to compare all 7 models data for that variable)

    % Hold on approach better aligns to plot first value of that variable from all models in one plot

    % However, user says: "then first go inside out1 of all files and then take the first value and plot it"
    % Means plot first data point or plot time series? 
    % Seems plot time series of each variable from all models, each variable 1 figure with up to 7 series

    fsz = 12;

    boldFont = {'FontWeight','bold','FontSize',fsz};
    tickweight = 'bold';

    % Create Results directory if missing
    if ~exist('Results','dir')
        mkdir('Results');
    end

    % Plot out1 variables
    for v = 1:length(out1_vars)
        varName = out1_vars{v};
        % Initialize time and data storage for CSV
        allData = [];
        timeVec = [];
        figureCounter = 1;

        % We'll compare 7 models in one plot for each out1 variable
        hFig = figure('Visible', ifelse(showPlots,'on','off'));
        hold on;
        legendNames = cell(1,7);

        for m = 1:7
            try
                ts = models{m}.out1.(varName);
                time = ts.Time;
                data = ts.Data;
                if isempty(timeVec)
                    timeVec = time;
                end
                plot(time, data,'DisplayName',sprintf('Model%d',m));
                legendNames{m} = sprintf('Model%d',m);
                % Collect data columnwise for CSV
                dataResize = interp1(time,data,timeVec,'linear','extrap');
                allData(:,m) = dataResize;
            catch
                % If missing data treat as nan
                npts = length(timeVec);
                if npts > 0
                    allData(:,m) = nan(npts,1);
                end
            end
        end
        hold off;
        grid on;
        xlabel('Time','FontWeight','bold');
        ylabel(varName, 'FontWeight','bold');
        title(['Comparison of ' varName ' across models'], 'FontWeight','bold');
        legend(legendNames,'Location','best');
        set(gca,'XTickLabelMode','auto','YTickLabelMode','auto',...
            'XColor','k','YColor','k','FontWeight','bold');
        set(gca,'FontWeight','bold');
        if savePlots
            folderPath = fullfile('Results',varName,'Images');
            if ~exist(folderPath,'dir')
                mkdir(folderPath);
            end
            saveas(hFig,fullfile(folderPath,[varName '_comparison.png']));
        end
        if ~showPlots
            close(hFig);
        end

        % Save CSV per variable
        csvFolder = fullfile('Results',varName);
        if ~exist(csvFolder,'dir')
            mkdir(csvFolder);
        end

        % Write CSV: first column Time, then all model data
        csvFilePath = fullfile(csvFolder,'Data.csv');
        tbl = table(timeVec);
        for m = 1:7
            colName = sprintf('Model%d',m);
            if size(allData,1) >= length(timeVec)
                tbl.(colName) = allData(:,m);
            else
                tbl.(colName) = nan(length(timeVec),1);
            end
        end
        writetable(tbl,csvFilePath);
    end

    % Now for out2 variables
    % For inject voltage and current - plot 2 per figure (max 3 figs)
    injVars = {'Injected_Voltage','Injected_Current'};
    otherVars = setdiff(out2_vars, injVars);

    % Plot non-inject variables each in own plot comparing 7 models
    for v=1:length(otherVars)
        varName = otherVars{v};
        allData = [];
        timeVec = [];
        hFig = figure('Visible', ifelse(showPlots,'on','off'));
        hold on;
        legendNames = cell(1,7);

        for m=1:7
            try
                ts = models{m}.out2.(varName);
                time = ts.Time;
                data = ts.Data;
                if isempty(timeVec)
                    timeVec = time;
                end
                plot(time,data,'DisplayName',sprintf('Model%d',m));
                legendNames{m} = sprintf('Model%d',m);
                % resize data for csv
                dataResize = interp1(time,data,timeVec,'linear','extrap');
                allData(:,m) = dataResize;
            catch
                % missing data treated as NaN
                npts = length(timeVec);
                if npts > 0
                    allData(:,m) = nan(npts,1);
                end
            end
        end
        hold off;
        grid on;
        xlabel('Time','FontWeight','bold');
        ylabel(varName, 'FontWeight','bold');
        title(['Comparison of ' varName ' across models'], 'FontWeight','bold');
        legend(legendNames,'Location','best');
        set(gca,'FontWeight','bold');
        if savePlots
            folderPath = fullfile('Results',varName,'Images');
            if ~exist(folderPath,'dir')
                mkdir(folderPath);
            end
            saveas(hFig,fullfile(folderPath,[varName '_comparison.png']));
        end
        if ~showPlots
            close(hFig);
        end

        % Save CSV
        csvFolder = fullfile('Results',varName);
        if ~exist(csvFolder,'dir')
            mkdir(csvFolder);
        end
        csvFilePath = fullfile(csvFolder,'Data.csv');
        tbl = table(timeVec);
        for m = 1:7
            colName = sprintf('Model%d',m);
            if size(allData,1) >= length(timeVec)
                tbl.(colName) = allData(:,m);
            else
                tbl.(colName) = nan(length(timeVec),1);
            end
        end
        writetable(tbl,csvFilePath);
    end

    % For Injected_Voltage and Injected_Current - plot 2 in one figure, 3 figures max
    % Collect these variables data for all models in two arrays, plot 2 per figure in pairs

    % We will group them by model index: i.e., figures with Model1 & Model2, Model3 & Model4, etc.
    % But user said: plot all models' Injected_Voltage in one subplot and Injected_Current in another subplot? Or plot separate images each with 2 vars per image?

    % User said: "Injected Voltage and Injected current use try catch block for only it plot like 2 plots in one image so there are only 6 plots for Injected_Voltage and Injected_current so, plot it 2 in one image so there will be total 3 images with 2 in one."

    % This means: For Models 1 to 7, Injected_Voltage and Injected_Current to plot in pairs of 2 models each figure: 
    % Actually unclear if user means plot Injected_Voltage and Injected_Current for all 7 models in 3 images, each image with 2 subplots (one for Injected_Voltage 7 models, second for Injected_Current 7 models),

    % Implementing 3 figures each with 2 subplots:
    % Each subplot has 7 models plotted, one subplot for Injected_Voltage, next for Injected_Current

    numPlots = 3;
    modelsPerPlot = 7; % All 7 models at once

    for i = 1:numPlots
        hFig = figure('Visible', ifelse(showPlots,'on','off'));
        % Subplot 1: Injected_Voltage
        subplot(2,1,1);
        hold on;
        legendNames = cell(1,7);
        timeVec = [];
        allDataVoltage = [];
        for m=1:7
            try
                ts = models{m}.out2.Injected_Voltage;
                time = ts.Time;
                data = ts.Data;
                if isempty(timeVec)
                    timeVec = time;
                end
                plot(time,data,'DisplayName',sprintf('Model%d',m));
                legendNames{m} = sprintf('Model%d',m);
                dataResize = interp1(time,data,timeVec,'linear','extrap');
                allDataVoltage(:,m) = dataResize;
            catch
                npts = length(timeVec);
                if npts > 0
                    allDataVoltage(:,m) = nan(npts,1);
                end
            end
        end
        hold off;
        grid on;
        xlabel('Time','FontWeight','bold');
        ylabel('Injected Voltage', 'FontWeight','bold');
        title('Injected Voltage comparison', 'FontWeight','bold');
        legend(legendNames,'Location','best');
        set(gca,'FontWeight','bold');

        % Subplot 2: Injected_Current
        subplot(2,1,2);
        hold on;
        legendNames = cell(1,7);
        timeVec = [];
        allDataCurrent = [];
        for m=1:7
            try
                ts = models{m}.out2.Injected_Current;
                time = ts.Time;
                data = ts.Data;
                if isempty(timeVec)
                    timeVec = time;
                end
                plot(time,data,'DisplayName',sprintf('Model%d',m));
                legendNames{m} = sprintf('Model%d',m);
                dataResize = interp1(time,data,timeVec,'linear','extrap');
                allDataCurrent(:,m) = dataResize;
            catch
                npts = length(timeVec);
                if npts > 0
                    allDataCurrent(:,m) = nan(npts,1);
                end
            end
        end
        hold off;
        grid on;
        xlabel('Time','FontWeight','bold');
        ylabel('Injected Current', 'FontWeight','bold');
        title('Injected Current comparison', 'FontWeight','bold');
        legend(legendNames,'Location','best');
        set(gca,'FontWeight','bold');

        if savePlots
            folderPath = fullfile('Results','Injected_Voltage_Injected_Current','Images');
            if ~exist(folderPath,'dir')
                mkdir(folderPath);
            end
            saveas(hFig,fullfile(folderPath,sprintf('Injected_Voltage_Current_%d.png', i)));
        end
        if ~showPlots
            close(hFig);
        end
    end

    % Save CSV for Injected Voltage and Current combined
    csvFolder = fullfile('Results','Injected_Voltage_Injected_Current');
    if ~exist(csvFolder,'dir')
        mkdir(csvFolder);
    end

    % Combine time vectors for Injected Voltage (assuming same as Injected Current)
    if exist('timeVec','var') && ~isempty(timeVec)
        tbl = table(timeVec);
    else
        tbl = table([]);
    end

    for m = 1:7
        try
            tsVolt = models{m}.out2.Injected_Voltage;
            dataV = tsVolt.Data;
            % Align interpolated data
            dataV = interp1(tsVolt.Time, dataV, timeVec, 'linear', 'extrap');
        catch
            dataV = nan(length(timeVec),1);
        end
        tbl.(sprintf('Model%d_InjectedVoltage',m)) = dataV;

        try
            tsCurr = models{m}.out2.Injected_Current;
            dataC = tsCurr.Data;
            dataC = interp1(tsCurr.Time, dataC, timeVec, 'linear', 'extrap');
        catch
            dataC = nan(length(timeVec),1);
        end
        tbl.(sprintf('Model%d_InjectedCurrent',m)) = dataC;
    end

    writetable(tbl, fullfile(csvFolder,'Data.csv'));
end

function out = ifelse(cond,trueVal,falseVal)
    if cond
        out = trueVal;
    else
        out = falseVal;
    end
end
