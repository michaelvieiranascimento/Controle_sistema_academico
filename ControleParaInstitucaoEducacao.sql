/* Criando as tres tabelas, usando chave primaria e estrangeira. E inserindo os dados. */
create table Aluno 
(
RA varchar(20) not null, 
Nome varchar(40) null,
Constraint Pk_Aluno Primary Key (RA)
);

create table Disciplina
(
Sigla varchar(20) not null,
Nome varchar(40) null,
CargaHoraria varchar(20) null,
Constraint Pk_Disciplina Primary Key (Sigla)
);
Select Sigla,Nome,CargaHoraria
from Disciplina

create table Matricula
(
Codigo varchar (20) not null,
RA_Aluno varchar(20) not null,
Sigla_Disciplina varchar(20) not null,
NP1 decimal(4,2) null,
NP2 decimal(4,2) null,
SUB decimal(4,2) null,
MediaNota decimal(4,2) null,
Falta int null,
MediaFalta decimal(4,2) null,
DataMatriculado date null,
SituacaoFinal varchar(20) null,
Constraint Pk_Matricula Primary Key (Codigo,RA_Aluno,Sigla_Disciplina),

Constraint Fk_Aluno Foreign Key(RA_Aluno)
						References Aluno(RA),

Constraint Fk_Disciplina Foreign Key(Sigla_Disciplina)
						References Disciplina(Sigla)
);

insert into Aluno (RA,Nome)
values('B343F34','Andre',
'C23132F','Maicon',
'D2312RF','Paulo',
'D8636G2','Igor',
'F2313G','Felipe',
'F8053F2','Lucas',
'L23141F2','Luan',
'P234F32','Gabriel',
'S2858F7','Rafael',
'W4423F334','Matheus')

insert into Disciplina (Sigla,Nome,CargaHoraria)
values
('ADA','ANALISE DE ALGORITMOS','25',
'ES','ENGENHARIA DE SOFTWARE','30',
'FRV','FUND REALIDADE VIRTUAL/AUMENT','35',
'IHC','INTERACAO HUMANO COMPUTADOR','60',
'SD','SISTEMAS DISTRIBUIDOS','55')


/*Calcula Media com a NP1, NP2 e a SUB do aluno, Se for maior ou igual a 5, o aluno estara Aprovado, se menor que 5, aluno estara reporvado*/
create proc MediaNota @NP1 decimal, @NP2 decimal, @SUB decimal, @RA_Aluno varchar(10), @Sigla_disciplina varchar(20), @SituacaoFinal varchar(20)
as
begin
	declare 
		@media float
	if isnull(@NP2,1) != 1 and isnull(@NP1,1) != 1
	begin
		if  isnull(@SUB, 1) = 1
		begin
			select @media = ((@NP1 + @NP2)/2)
			if @media <5
			begin 
				print 'Abaixo da media, necessita fazer a prova substitutiva'
			end

			if @media >=5
			begin
				print 'Aprovado'
				update Matricula set SituacaoFinal = 5 
			end
			update Matricula set MediaNota = @media 
		end

		if isnull(@SUB, 1) != 1
		begin
			if @NP1 < @NP2
			begin
				select @media = ((@SUB + @NP2)/2)
				if @media <5
				begin
					print 'Reprovado por nota'
					update Matricula set SituacaoFinal = 2
				end
				if @media >=5
				begin
					print 'Aprovado'
					update Matricula set SituacaoFinal = 5 
				end
				update Matricula set MediaNota = @media 
			end

			if @NP1 >= @NP2
			begin
				select @media = ((@NP1 + @SUB)/2)
				if @media <5
				begin
					print 'Reprovado por nota'
					update Matricula set SituacaoFinal = 2 
				end
				if @media >=5
				begin
					print 'Aprovado'
					update Matricula set SituacaoFinal = 5 
				end
				update Matricula set MediaNota = @media 
			end
		end
	end
end;

/* Calcula Frequencia do Aluno na disciplina selecionado*/
create proc CalculoFrequencia @RA_Aluno varchar(20),@Sigla_Disciplina int, @Falta int
as
begin
	declare
		@horas_disc int
	select @horas_disc = CargaHoraria from Disciplina where Sigla = @Sigla_Disciplina
	if @Falta > (0.25*@horas_disc)
	begin
		print'Reprovado por falta'
		update Matricula set SituacaoFinal = 3
	end
end;
