% Algoritmo adaptativo extendido

% Leer la imagen
% img = imread('D:\oneDrive - U\OneDrive - Universidad Distrital Francisco José de Caldas\IA2 - Primer corte\08 - visión artificial\test.jpg');
% img = imread('D:\oneDrive - U\OneDrive - Universidad Distrital Francisco José de Caldas\IA2 - Primer corte\08 - visión artificial\test2.jpg');
% img = imread('D:\oneDrive - U\OneDrive - Universidad Distrital Francisco José de Caldas\IA2 - Primer corte\08 - visión artificial\test3.jpg');
img = imread('D:\oneDrive - U\OneDrive - Universidad Distrital Francisco José de Caldas\IA2 - Primer corte\08 - visión artificial\plano.png');
img = rgb2gray(img);

tic

% Agregar una columna al inicio y al final de la imagen
img = [img(:,1), img, img(:,end)];

% Agregar una fila al inicio y al final de la imagen
img = [img(1,:); img; img(end,:)];

% Inicializar matriz de salida
edgeImg = zeros(size(img));

% Definir vecindario de Moore
neighborhood = [1 1 1; 1 0 1; 1 1 1];

% Obtener el tamaño del vecindario
[nRows, nCols] = size(neighborhood);

% Obtener la cantidad de filas y columnas de la imagen
[imgRows, imgCols] = size(img);

% Definir el tamaño del vecindario extendido
win_size = 3;

% Iterar sobre los píxeles de la imagen
for row = win_size + 1:imgRows - win_size
    for col = win_size + 1:imgCols - win_size

        % Obtener vecindario extendido
        nVals = zeros((2 * win_size + 1) ^ 2, 1);
        nIdx = 1;

        for i = -win_size:win_size

            for j = -win_size:win_size
                nVals(nIdx) = img(row + i, col + j);
                nIdx = nIdx + 1;
            end
        end

        % Obtener el promedio y la variación del vecindario
        nAvg = mean(nVals);
        nVar = std(nVals);

        % Asignar valor de borde o no borde según el criterio establecido
        if img(row, col) > nAvg
            edgeImg(row, col) = 0;
        elseif nVar < 4
            edgeImg(row, col) = 0;
        else
            edgeImg(row, col) = 255;
        end
    end
end
% Definir tamaño de la ventana extendida
win_size = 3;

% Inicializar matriz de salida
out = edgeImg;

% Segunda iteración: afinamiento de bordes
for i = 1:size(img, 1)

    for j = 1:size(img, 2)
        % Si el pixel es borde
        if out(i, j) == 1
            % Calcula el promedio del vecindario extendido
            if (i > win_size + 1) && (j > win_size + 1) && (i < size(img,1)-win_size) && (j < size(img,2)-win_size)
                % Si el pixel está dentro de los límites de la imagen, utiliza el vecindario extendido
                i_min = i - win_size - 1;
                i_max = i + win_size + 1;
                j_min = j - win_size - 1;
                j_max = j + win_size + 1;

                win_ext = img(i_min:i_max, j_min:j_max);
                win_mean = sum(win_ext(:)) / numel(win_ext);

            else
                % Si el pixel está en los bordes de la imagen, utiliza el vecindario normal
                neighborhood_vals = img(i-1:i+1,j-1:j+1);
                win_mean = mean(neighborhood_vals(:));
            end

            % Si el valor del pixel es mayor que el promedio, lo elimina
            if img(i, j) > win_mean
                out(i, j) = 0;
            end
        end
    end
end

% Mostrar la imagen original y la imagen de bordes con afinamiento
% figure;
% subplot(1, 2, 1); imshow(img); title('Imagen Original');
% subplot(1, 2, 2); 

toc

imshow(out); 
% title('Imagen de bordes con afinamiento');
