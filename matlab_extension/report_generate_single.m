
function report_generate_single(definitions,save_name,saving_path,report_content,...
                odes,start_time,end_time,chosen_solvers,legend_strings,t,solutions)

import mlreportgen.dom.*

fprintf('\n\nConstructing report ... '); 
plot_path = [saving_path,'my.png'];
report_path = [saving_path,save_name];


if strcmp(num2str(save_name((length(save_name)-2):end)),'tml')
   report = Document(report_path,'HTML-FILE');
elseif sum(save_name((length(save_name)-2):end)=='pdf')==3
    try
        report = Document(report_path,'pdf');
    catch
        warning('PDF is invalid. Generate html report instead.');
        save_name((length(save_name)-3):end)=[];
        save_name = [save_name,'.html'];
        report_path = strcat(saving_path,save_name);
        report = Document(report_path,'HTML-FILE');
    end
end

% 1. code
if (report_content.Code==1)
    h1 = Heading(1, 'Code');
    text1=Text(definitions);
    %text1=Text(strtrim(definitions));
    p1 = Paragraph(text1);

    append(report,h1);
    append(report,p1);
end

% 2. odes
if (report_content.ODEs==1)

    h2 = Heading(1, 'ODES');
    append(report,h2);

    for i = 1:length(odes)
        p2 = Paragraph('');
        append(p2, odes{i});
        append(report,p2);
    end
end


%3. plot
if (report_content.Plot==1)
    
    plot1 = Image(plot_path);
    if length(chosen_solvers)==2
        a=1
        plot1.Style = {Height('45%'), Width('90%')};
    else
        a=2
        plot1.Style = {Height('80%'), Width('80%')};
    end
    
    h3 = Heading(1, 'Plot');
    t3=['Process Pi was plotted from  time ',num2str(start_time),' to ', num2str(end_time)];
    p3 = Paragraph(t3);
    
    append(report,h3);
    append(report,p3);
    append(report,plot1);
end

%4. numeritic
if (report_content.Num==1)

    h4 = Heading(1, 'Numerical Solutions');
    append(report,h4);
    
    
%     for m = 1:length(chosen_solvers)
%     
%         ode_name = strsplit(chosen_solvers{m}, ' ');
%         t4 = ['Solutions for solver ', ode_name{1}, ':'];
%         p4 = Paragraph(t4);
%         append(report,p4); 
% 
%         te = [];
%         te(:,1) = t{m};
%         te(:,2:(length(legend_strings)+1)) = Y{m}(:,1:length(legend_strings));
%         table_entries = (round(te, 3));      
%         %table_entries = num2cell(round(te, 3));
%              
%         table= FormalTable(table_entries);
%         
%         r = TableRow();
%         append(r,TableEntry('Time(s)'));
%         for i = 1:length(legend_strings)
%            append(r,TableEntry(legend_strings{i}));           
%         end
%         append(table.Header,r);
%         
%         table.Border = 'single';
%         table.ColSep = 'single';
%         table.RowSep = 'single';
%         grps(1)=TableColSpecGroup;
%         grps(1).Span=6;
%         grps(1).Style = {Width('1in')};
%         table.ColSpecGroups = grps;
%         append(report,table);           
%     end

    for m = 1:length(chosen_solvers)
        ode_name = strsplit(chosen_solvers{m}, ' ');
        t4 = ['Solutions for solver ', ode_name{1}, ':'];
        p4 = Paragraph(t4);
        append(report,p4); 
        
        table = FormalTable((length(legend_strings)+1));
        
        for p = 1:size(solutions{m}, 1)
            r = TableRow();
            append(r,TableEntry(num2str(round(t{m}(p), 3))));
            for q = 1:length(legend_strings)
                append(r,TableEntry(num2str(round(solutions{m}(p, q), 3))));                
            end
            
            append(table.Body,r);
        end
        
       % table = Table((length(legend_strings)+1))
        r = TableRow();
        append(r,TableEntry('Time(s)'));
        for i = 1:length(legend_strings)
           append(r,TableEntry(legend_strings{i}));           
        end
        r.Style={Bold};
        append(table.Header,r);
        
        %table.Style = {RowHeight('0.1in')};
        table.Border = 'Single';
        table.ColSep = 'Single';
        table.RowSep = 'Single';
        
        if length(legend_strings)<=9
            table.Width = '50%';
        else
            table.Width = '80%';
        end
        
        grps(1)=TableColSpecGroup;
        grps(1).Span= length(legend_strings)+1;       
        grps(1).Style = {Width('1%')};
        table.ColSpecGroups = grps;
        %table.Style = {ResizeToFitContents(true)};
        append(report,table); 
    end

end


close(report);
rptview(report.OutputPath);
fprintf('Done.');

end


% plot1 = Image('myPlot_img.png');
% plot1.Style = {Height('80%'), Width('80%')};
% 
% 
% h1 = Heading(1, 'Code');
% text1=Text(definitions);
% p1 = Paragraph(text1);
% 
% h2 = Heading(1, 'ODES');
% 
% h3 = Heading(1, 'Plot');
% t3=['Process Pi was plotted from  time ',num2str(start_time),' to ', num2str(end_time)];
% p3 = Paragraph(t3);&report_content.Num==0
% 
% 
% 
% append(report,h1);
% append(report,p1);
% append(report,h2);
% 
% 
% for i = 1:length(odes)
%     p2 = Paragraph('');
%     append(p2, odes{i});
%     append(report,p2);
% end
% 
% append(report,h3);
% append(report,p3);
% append(report,plot1);


% close(report);
% rptview(report.OutputPath);
% %rptview('myreport.html','pdf')
