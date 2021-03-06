#include "UnmanagedOpenCL.h"
#pragma once
using namespace System;
#pragma managed
#include "clix.h"


namespace ManagedOpenCLWrapper
{
	public ref class ManagedOpenCL
	{
	private:
		UnmanagedOpenCL* _UMOpenCL;

	public:
		ManagedOpenCL();
		~ManagedOpenCL();

		void setCLdev(int i);
		int getCLdevCount();
		String^ getCLdevString(int i, bool getShort);
		uint64_t getCLdevGlobalMemory();
		int getCLMemoryUsed();

		void importStructure(String^ filepath);
		void uploadParameterisation();
		void getStructureDetails(Int32% Len, float% MinX, float% MinY, float% MinZ, float% MaxX, float% MaxY, float% MaxZ);
		void getNumberSlices(Int32% Slices, bool FD);
		void sortStructure(bool tds);

		void doMultisliceStep(int stepno, int steps);
		void doMultisliceStep(int stepno, int steps, int waves);

		void setCTEMParams(float df, float astigmag, float astigang, float kilovoltage, float spherical, float beta, float delta, float aperture, float astig2mag, float astig2ang, float b2mag, float b2ang);
		void setSTEMParams(float df, float astigmag, float astigang, float kilovoltage, float spherical, float beta, float delta, float aperture);

		void initialiseCTEMSimulation(int resolution, float startx, float starty, float endx, float endy, bool Full3D, bool FD, float dz, int full3dints);
		void initialiseSTEMSimulation(int resolution, float startx, float starty, float endx, float endy, bool Full3D, bool FD, float dz, int full3dints, int waves);

		void initialiseSTEMWaveFunction(float posx, float posy);
		void initialiseSTEMWaveFunction(float posx, float posy, int wave);

		void simulateCTEM();
		void simulateCTEM(int detector, int binning);

		void getCTEMImage(array<float>^ data, int resolution);
		void getCTEMImage(array<float>^ data, int resolution, float dose, int binning, int detector);

		void getEWImage(array<float>^ data, int resolution);
		void getEWImage(array<float>^ data, int resolution, int wave);
		void getEWImage2(array<float>^ data, int resolution);
		void getEWImage2(array<float>^ data, int resolution, int wave);
		void getDiffImage(array<float>^ data, int resolution);
		void getDiffImage(array<float>^ data, int resolution, int wave);

		float getCTEMMax();
		float getCTEMMin();
		float getEWMax();
		float getEWMin();
		float getEWMax2();
		float getEWMin2();
		float getDiffMax();
		float getDiffMax(int wave);
		float getDiffMin();
		float getDiffMin(int wave);

		void getSTEMDiff(int wave);
		float getSTEMPixel(float inner, float outer, float xc, float yc, int wave);

		void addTDS();
		void addTDS(int wave);
		void clearTDS();
		void clearTDS(int wave);

	};
}