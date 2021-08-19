%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

function tbl=tblMainGrades(tbl)
    ind1=tbl.Grade=='E1';
    ind2=tbl.Grade=='E2';
    
    if any(ind1) && any(ind2)
        tbl.Grade(ind1)={'E'};
        tbl.Count(ind1)=tbl.Count(ind1)+tbl.Count(ind2);
        tbl.Percent(ind1)=tbl.Percent(ind1)+tbl.Percent(ind2);
        tbl(ind2,:)=[];
    elseif any(ind1) 
        tbl.Grade(ind1)={'E'};
    elseif any(ind2)
        tbl.Grade(ind2)={'E'};
    end

end