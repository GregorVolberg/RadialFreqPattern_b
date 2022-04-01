tmp = dir('*.mat')
flist = {tmp.name};

for j = 1:numel(flist)
clear RFP
load(flist{j});
save(flist{j}, 'RFP', '-v7');
end