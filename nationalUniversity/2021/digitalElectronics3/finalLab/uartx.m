%% TRABAJO FINAL ED3
% Integrantes:
% *ALANIZ, Darío
% *FERRARIS, Domingo
% *GOMEZ, Augusto Rodrigo

% INITIALIZATION
clear;clc;
% s= serial('COM3', 'BaudRate', 115200, 'ByteOrder','littleEndian');
s=serial('/dev/ttyUSB0', 'BaudRate', 115200, 'ByteOrder','littleEndian');
s.InputBufferSize= 20; %bytes del buffer
s.Terminator= 0; 
fopen(s);

% INTERFACE
sep= '//---------------------------------------------------------------------------//\n';
fprintf(sep);
fprintf('\t\tPROYECTO FINAL ED3\n');
fprintf('Escriba un comando para seguir, se pueden consultar los que estan\ndisponibles escribiendo "cmd".\n');
fprintf(sep);

exit_flag=0;
while exit_flag == 0
    cmd = input('Ingrese un comando >> ','s');
    switch cmd
        case 'cmd'
            fprintf('\nComandos disponibles:\n');
            fprintf('\t* "exit" -> cerrar el programa\n');
            fprintf('\t* "record" -> grabar mensaje a transmitir\n');
            fprintf('\t* "getkey" -> obtener clave de validacion actual del receptor\n');
            fprintf('\t* "setkey" -> modificar clave de validacion del receptor\n');
        case 'exit'
            exit_flag=1;
        case 'record'
            fprintf(s,'.r');
        case 'getkey'
            fprintf(s,'.g');
            currentKey= fread(s,1,'uint32');
            fprintf("La clave actual es: 0x"+ num2str(currentKey, '%.8x') + "\n");
        case 'setkey'
            newKey= input('Ingrese la nueva clave de validación (8 digitos en HEX) >> ','s');
            if hex2dec(newKey) > (2^32-1)
                fprintf('Error, la clave no es valida\n');
            else
                fprintf(s, '.s');
                readyToLoad= fread(s,1,'uint8');
                if (readyToLoad == 1)
                    fwrite(s,hex2dec(newKey),'uint32');
                    fprintf("Clave cargada con exito.\n")
                else
                    fprintf('Ocurrio un error cargando la nueva clave\n');
                end
            end
        otherwise
            fprintf('\t*COMANDO INVALIDO*\n');
    end
end

%cerrar puerto
fclose(s);

%%
flushinput(s);
flushoutput(s);
%% Close serial port
fclose(s);
delete(s);
clear s
%fclose(instrfind);

%% Read data
% flushinput(s);
%data= fread(s, 1, 'uint32');
%dec2hex(data)