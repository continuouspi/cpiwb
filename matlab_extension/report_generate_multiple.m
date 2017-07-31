function report_generate_multiple(model_names,definations, save_name, saving_path, start_time, end_time, report_content)

import mlreportgen.dom.*

fprintf('\n\nConstructing report ... '); 

plot_path = [saving_path,'my_plot.png'];
report_path = [saving_path,save_name];

if strcmp(num2str(save_name((length(save_name)-2):end)),'tml')
   report = Document(report_path,'HTML-FILE');
elseif sum(save_name((length(save_name)-2):end)=='pdf')==3
    try
        report = Document(report_path,'pdf');
    catch
        warning('PDF is invalid. using html instead.');
        save_name((length(save_name)-3):end)=[];
        save_name = [save_name,'.html'];
        report_path = strcat(saving_path,save_name);
        report = Document(report_path,'HTML-FILE');
    end
end


if (report_content.Code==1)
    
    h1 = Heading(1, 'Code');
    append(report,h1);
    
    text1=Text(model_names{1});
    %text1.Bold = 1;
    p1 = Paragraph(text1);  
    p1.Bold = true;
    append(report,p1);
    
    text2=Text(strtrim(definations{1}));
    p2 = Paragraph(text2);
    append(report,p2);
  
    if length(model_names) > 1 
        for i = 2:length(model_names)
            flag = 0;
            for j = 1:(i-1)
                if strcmp(model_names{i},model_names{j})
                   flat = 1; 
                end
            end
            
            if flag == 0
                text1=Text(model_names{i});
                p1 = Paragraph(text1);
                p1.Bold = true;
                append(report,p1);
                text2=Text(strtrim(definations{i}));
                p2 = Paragraph(text2);
                append(report,p2);
            end
        end
    end
end


if (report_content.Plot==1)
    plot1 = Image(plot_path);
    plot1.Style = {Height('80%'), Width('80%')};

    h3 = Heading(1, 'Plot');
    t3=['Process Pi was plotted from  time ',num2str(start_time),' to ', num2str(end_time)];
    p3 = Paragraph(t3);
    
    append(report,h3);
    append(report,p3);
    append(report,plot1); 
end


close(report);
rptview(report.OutputPath);
fprintf('Done.');

end