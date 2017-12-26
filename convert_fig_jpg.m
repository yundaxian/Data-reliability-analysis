function [] = convert_fig_jpg(fig_dir)
% obtain the files with .fig extension
dirName = fig_dir;
files = dir( fullfile(dirName,'*.fig') );
files = {files.name};                      %
disp(files);
files = dir('*.fig');

%loop through the .fig files
for i=1:length(files)

   %obtain the filename of the .fig file
   filename = files(i).name;

   %open the figure without plotting it
   fig = openfig(filename, 'new', 'invisible');

   %save the figure as a jpg
   saveas(fig, [filename '.jpg']);

   %close the figure so that the next could be opened without some java problem
   close;

end