function XYZ_Out = Read_tTEM_XYZ(Path)

% Path = 'C:\Users\gko4\Documents\Postdoc Projects\Dahlke Moore_EPA\tTEM Inversions\2019 Terranova\TN1_SCI_Sm_02_I01_MOD_inv.xyz';

if ~iscell(Path)
    Path = {Path};
end

UTMX = [];
UTMY = [];
Elevation = [];
DataResidual= [];
TotalResidual = [];
DOI_Conservative = [];
DOI_Standard = [];
Rho = [];
RhoStd = [];
DepthB = [];
Thk = [];

for i = 1 : size(Path, 1)
    fid = fopen(Path{i});
    
    x = fgetl(fid);
    ct = 0;
    while x~=-1
        
        x = fgetl(fid);
        ct = ct + 1;
    end
    
    fclose(fid);
    
    fid = fopen(Path{i});
    XYZ = cell(ct, 1);
    
    for c = 1 : ct
        XYZ{c} = fgetl(fid);
    end
    
    fclose(fid);
    
    %%
    
    % nGatesCell = XYZ(find(contains(XYZ, '/NUMBER OF GATES')) + 1);
    % nGates = str2double(nGatesCell{1}(2:end));
    
    % GatesCell = XYZ(find(contains(XYZ, '/GATE TIMES')) + 1);
    % TimeGates = str2num(GatesCell{1}(2:end));
    
    nLayersCell =  XYZ(find(contains(XYZ, '/NUMBER OF LAYERS')) + 1);
    nLayers = str2double(nLayersCell{1}(2:end));
    
    nHeader = find(contains(XYZ, '/ LINE_NO'));
    nData = ct - nHeader;
    
    %%
    
    XYZ_Data = str2num(cell2mat(XYZ(nHeader + 1 : end)));
    
    XYZ_Header = strsplit(XYZ{nHeader});
    
    UTMX_Col = find(contains(XYZ_Header, 'UTMX')) - 1;
    UTMY_Col = find(contains(XYZ_Header, 'UTMY')) - 1;
    Elev_Col = find(contains(XYZ_Header, 'ELEVATION')) - 1;
    DataResidual_Col = find(contains(XYZ_Header, 'RESDATA')) - 1;
    TotalResidual_Col = find(contains(XYZ_Header, 'RESTOTAL')) - 1;
    
    Rho1_Col = find(contains(XYZ_Header, 'RHO_I_1')) - 1;
    RhoStd1_Col = find(contains(XYZ_Header, 'RHO_I_STD1')) - 1;
    DepthB1_Col = find(contains(XYZ_Header, 'DEP_BOT_1')) - 1;
    Thk1_Col = find(contains(XYZ_Header, 'THK_1')) - 1;
    
    DOI_Conservative_Col = find(contains(XYZ_Header, 'DOI_CONSERVATIVE')) - 1;
    DOI_Standard_Col = find(contains(XYZ_Header, 'DOI_STANDARD')) - 1;
    
    UTMX_Temp = XYZ_Data(:, UTMX_Col);
    UTMY_Temp = XYZ_Data(:, UTMY_Col);
    Elevation_Temp = XYZ_Data(:, Elev_Col);
    DataResidual_Temp = XYZ_Data(:, DataResidual_Col);
    TotalResidual_Temp = XYZ_Data(:, TotalResidual_Col);
    Rho_Temp = XYZ_Data(:, Rho1_Col : Rho1_Col + nLayers - 1);
    RhoStd_Temp = XYZ_Data(:, RhoStd1_Col : RhoStd1_Col + nLayers - 1);
    DepthB_Temp = [XYZ_Data(:, DepthB1_Col : DepthB1_Col + nLayers - 2) inf*ones(nData, 1)];
    Thk_Temp = XYZ_Data(:, Thk1_Col : Thk1_Col + nLayers - 1);
    DOI_Conservative_Temp = XYZ_Data(:, DOI_Conservative_Col);
    DOI_Standard_Temp = XYZ_Data(:, DOI_Standard_Col);
    
    
    UTMX = [UTMX; UTMX_Temp];
    UTMY = [UTMY; UTMY_Temp];
    Elevation = [Elevation; Elevation_Temp];
    DataResidual= [DataResidual; DataResidual_Temp];
    TotalResidual = [TotalResidual; TotalResidual_Temp];
    DOI_Conservative = [DOI_Conservative; DOI_Conservative_Temp];
    DOI_Standard = [DOI_Standard; DOI_Standard_Temp];
    Rho = [Rho; Rho_Temp];
    RhoStd = [RhoStd; RhoStd_Temp];
    DepthB = [DepthB; DepthB_Temp];
    Thk = [Thk; Thk_Temp];
end
XYZ_Out = table(UTMX, UTMY, Elevation, DataResidual, TotalResidual, DOI_Conservative, DOI_Standard, Rho, RhoStd, DepthB, Thk);
end