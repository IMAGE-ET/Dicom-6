%Leitura de Imagens
clear all;

%Conexao com o banco de dados
mym('open','localhost:3306','root','123456');
mym('status');
mym('use','webpacs');

%Captura o tempo atual da CPU
ti=cputime;

%Nimagens = Numero de Imagens
Nimagens=2;

%Leitura das Imagens
for im=1:Nimagens
    jm=im;
   jm=num2str(jm);
   jm=strcat(jm,'.dcm');
   imagem=dicomread(jm);
   %img(:,:,:,im)=imagem;
   
   info = dicominfo(jm);
   X = dicomread(info);
   
%Comum em todas as imagens
Id = info.PatientID
Nome = getfield(info.PatientName, 'FamilyName')
dataNascimento = info.PatientBirthDate
Sexo = info.PatientSex
Modalidade = info.Modality
dataExame = info.StudyDate

switch(im)
    case 1
    %Itens exclusivos da imagem
    idExame = info.StudyID
    idImagem = info.SOPInstanceUID

    %Conversao 1
    W = im2double(imagem);
     mkdir('C:\htdocs\imagensJPG',idExame);
     mkdir('C:\htdocs\imagensDCM',idExame);
    imwrite(imadjust(W), fullfile('C:\htdocs\imagensJPG', num2str(idExame), '1.jpg'), 'jpg');
	
	%Preservando os direitos
	Nome='XxxXXxxXXxXXX';
	
    %Armazenamento 1: Armazena os itens comuns e os exclusivos da imagem
    mym('INSERT INTO paciente(idPaciente,nome,dataNascimento,sexo) VALUES("{S}","{S}","{S}","{S}")',Id,Nome,dataNascimento,Sexo);
    mym('INSERT INTO exame(idExame,idPaciente,modalidade,dataExame) VALUES("{S}","{S}","{S}","{S}")',idExame,Id,Modalidade,dataExame);
    mym('INSERT INTO imagem(idImagem, idPaciente, idExame, imagemJPG, imagemDCM) VALUES("{S}","{S}","{S}","{S}","{S}")',idImagem,Id,idExame,'1.jpg','1.dcm');
	
	%Copiando imagem DCM 1
    copyfile('1.dcm',fullfile('C:\htdocs\imagensDCM', num2str(idExame), '1.dcm'));
    
    case 2
    %Itens exclusivos da imagem
    idExame2 = info.StudyID
    idImagem2 = info.SOPInstanceUID

    %Conversao 2: Armazena apenas os itens exclusivos da imagem
    W = im2double(imagem);
    imwrite(imadjust(W), fullfile('C:\htdocs\imagensJPG', num2str(idExame), '2.jpg'), 'jpg');

    %Armazenamento 2
    mym('INSERT INTO imagem(idImagem, idPaciente, idExame, imagemJPG, imagemDCM) VALUES("{S}","{S}","{S}","{S}","{S}")',idImagem2,Id,idExame2,'2.jpg','2.dcm');
	
	%Copiando imagem DCM 2
	copyfile('2.dcm',fullfile('C:\htdocs\imagensDCM', num2str(idExame), '2.dcm'));
        
    end;

%Contador que adiciona mais uma imagem apos a verificacao
jm=im+1;

end;

%Fecha conexao com o banco de dados
mym('close','localhost:3306','root','123456');

%Subtrai o tempo atual do tempo inicial e registra o tempo de para ler
%todas as imagens em Ttotal
Ttotal=cputime-ti;


 
