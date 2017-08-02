function report_generate_multiple(model_names,definations, save_name, saving_path, start_time, end_time, report_content,font)

import mlreportgen.dom.*

fprintf('\n\nConstructing report ... '); 

plot_path = [saving_path,'my_plot.png'];
report_path = [saving_path,save_name];

if strcmp(num2str(save_name((length(save_name)-2):end)),'tml')
    report_tpye = 'html';
elseif sum(save_name((length(save_name)-2):end)=='pdf')==3
    report_tpye = 'pdf';
else
    fprintf('Error: invalid format');
    return
end    

if strcmp(report_tpye,'html')
   report = Document(report_path,'HTML-FILE');
else
    try
        report = Document(report_path,'pdf');
        
        %insert page number
        open(report);
        footer = PDFPageFooter('default');
        report.CurrentPageLayout.PageFooters = footer;
        report.CurrentPageLayout.FirstPageNumber = 1;
        pageinfo = Paragraph();
        pageinfo.HAlign = 'center';
        append(pageinfo,Page());
        append(footer,pageinfo);
        
    catch
        warning('PDF is invalid. Generate html report instead.');
        save_name((length(save_name)-3):end)=[];
        save_name = [save_name,'.html'];
        report_path = strcat(saving_path,save_name);
        report = Document(report_path,'HTML-FILE');
    end
end


if report_content.toc ==1
    try        
        p = Paragraph('Table of Contents');  
        if strcmp(report_tpye,'html')
            p.Style = {Bold(true),FontSize('22pt')};
        else
            p.Style = {Bold(true),FontSize('16pt')};
        end    
        toc = TOC(1,' ');
        toc.Style = {PageBreakBefore};
        append(report,p);
        append(report,toc);
    catch
        warning('TOC is invalid. TOC will not be generated.')
    end
end

if  isstruct(font) 
    
    if strcmp(font.FontWeight,'bold')
        Bold_option = true;
    else
        Bold_option = false;
    end

    if strcmp(font.FontAngle,'italic')
        Italic_option = true;
    else
        Italic_option = false;
    end       

    font_option = {FontFamily(font.FontName),FontSize([num2str(font.FontSize),'pt']),...
        Bold(Bold_option),Italic(Italic_option),WhiteSpace('preserve')};
else
    
    font_option = {FontFamily(),FontSize(),Bold(false),Italic(false),WhiteSpace('preserve')};
end


if (report_content.Code==1)
    
    h1 = Heading(1, 'Code');
    append(report,h1);
    
    text1=Text(model_names{1});
    
    p1 = Heading(2,text1);  
    %p1.Style = font_option;
    %p1.Bold = true;
    append(report,p1);
    
    text2=Text(strtrim(definations{1}));
    p2 = Paragraph(text2);
    p2.Style = font_option;
    append(report,p2);
    
    if length(model_names) > 1 
        for i = 2:length(model_names)
            flag = 0;
            for j = 1:(i-1)
                if strcmp(model_names{i},model_names{j})
                   flag = 1; 
                end
            end
            
            if flag == 0
                text1=Text(model_names{i});
                p1 = Heading(2,text1);
                %p1.Style = font_option;
                %p1.Bold = true;
                append(report,p1);
                text2=Text(strtrim(definations{i}));
                p2 = Paragraph(text2);
                p2.Style = font_option;
                append(report,p2);
            end
        end
    end
end


if (report_content.Plot==1)
    plot1 = Image(plot_path);
    
    if strcmp(num2str(save_name((length(save_name)-2):end)),'tml')
        plot1.Style = {Width('90%')};
    else
        plot1.Style = { ScaleToFit};
    end
    
    h3 = Heading(1, 'Plot');
    t3=['Process Pi was plotted from  time ',num2str(start_time),' to ', num2str(end_time),'.'];
    p3 = Paragraph(t3);
    p3.Style = font_option;
    
    append(report,h3);
    append(report,p3);
    append(report,plot1); 
end


close(report);
rptview(report.OutputPath);
delete(plot_path);
fprintf('Done.');

end