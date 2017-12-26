function sheet = clean_data(sheet)
[r c] = size(sheet);

if sheet(1,1) < 0
    sheet(1,:) = [];
end
for j=2:r
    if sheet(j,1) < 0
        sheet(j,:) = [];
        break;
    end
    if sheet(j-1,1) > sheet(j,1)
        sheet(j,:) = [];
        break;
    end    
end

end