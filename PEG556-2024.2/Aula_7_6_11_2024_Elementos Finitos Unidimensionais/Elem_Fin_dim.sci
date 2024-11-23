clear;clc;//hold on;
// modulo E, Area A, L: comprimento de barra
E  = 30e6;A=1;EA=E*A; L = 90;  

// geracao de elementos e nos
numx     = 3;    // número de elementos
node=linspace(0,L,numx+1);  // linspace(X1,X2,N): divide uma linha em N pontos entre X1 and X2
//disp(node)
node1=[(node(1:4))', [0 0 0 0 ]'];
//disp(node1)
// Define os nós, elementos e número de GLs
xx=node;
ii=1:numx; //segmentos
//disp(ii) 
element(:,1)=ii;
element(:,2)=ii+1; 
// disp(element) => matriz de conectividade
numnode=size(node,2);
numelem=size(element,1);
ndof=numnode;

//matriz de rigidez
K=sparse([], [],[numnode,numnode]);
//disp(full(K));

for e=1:numelem; 
  indice=element(e,:); // vetor  graus de liberdade em cada elemento
//  disp(indice) 
  nn=length(indice);   // comprimento do vector indice   
  //disp(nn) 
  length_element=node(indice(2))-node(indice(1)); // comprimento do elemento
 // disp( length_element)
  detJ0=length_element/2;  // /2 devido ao ponto de gauss central (xi=0, peso W=2)
//   disp(detJ0)
  invJ0=1/detJ0;   // J^-1
      N=([1,1]/2)';  // matriz funcoes de forma 
      dNdxi=[-1;1]/2;  // derivada da matriz funcoes de forma em relação às coordenadas naturais (ou globais)
      dNdx=dNdxi*invJ0; // derivada da matriz funcoes de forma em relação à X (coordenadas locais)
//      disp(dNdx)
   
// matriz B     *** [K] = somatório de [B]^T.[D].[B].|J| ,  sendo [D] = E.A  ***
B=zeros(1,nn);  // [B]= [-1/L  1/L]: vetor das deformações 
B(1:nn)  = dNdx(:); 
//   disp(B)
K(indice,indice)=K(indice,indice)+B'*B*2*detJ0*EA;
//disp(full(K));
end   

//vector de forcas
f=zeros(numnode,1);
f(2)=3000.0;

// Condicoes fronteira e solucao
fixedNodeW =find(xx==min(node(:)) | xx==max(node(:)))'; dofs=[fixedNodeW];
//disp(dofs); //fixou o primeiro e ultimo nós

U=zeros(numnode,1);
activos=setdiff([1:ndof]',[dofs]);
U=K(activos,activos)\f(activos);
U1=zeros(ndof,1);
U1(activos)=U;
U=U1
//disp(U);

// tensoes
stress=zeros(numelem,size(element,2),1);  
  stressPoints(1)=[-1];stressPoints(2)=[1]; 
for e=1:numelem                          
  indice=element(e,:); indiceB=[indice]; nn=length(indice);
  for q=1:nn
    pt=stressPoints(q);
      N=([1-pt,1+pt]/2)';
      dNdxi=[-1;1]/2;
    dNdx=dNdxi*invJ0;
// B     
    B=zeros(1,nn);  B(1:nn)  = dNdx(:)'; 
// deformacao do elemento no ponto de tensao
    strain=B*U(indiceB);  stress(e,q)=E*strain;
  end                               
end 
 disp('O valor das tensões (MPa) em cada segmento:',stress(:,1)); 
 Y = node'+U*1000
//disp(Y);
plot(node,0,'bo', Y,0,'ro')
legend("original", "deslocado")
xgrid
