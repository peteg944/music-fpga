# FPGA-Driven DSP Filtering and Visualization for Audio - Team Enlightened, EC551, Boston University

The purpose of this project is to demonstrate the use of audio processing for the management of program states and visualization. By connecting and integrating multiple types of peripherals onto an FPGA board, applications that could benefit from low latency, such as audio processing, dynamic lighting, and responsiveness to environment, can be fully showcased. The potential for use along with current home automation systems, where multiple tasks need to be carried out simultaneously and quickly, is well demonstrated in this way.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites
### Hardware

* [Electret Microphone Amplifier - MAX4466 with Adjustable Gain](https://www.adafruit.com/products/1063)
* [MCP3008 - 8-Channel 10-Bit ADC With SPI Interface](https://www.adafruit.com/products/856)
* [5V 2A (2000mA) switching power supply](https://www.adafruit.com/products/276)
* [32X32 RGB LED Matrix Panel - 6mm Pitch](https://www.adafruit.com/product/1484)

### Software

You need the following installed on your computer:

```
ISE Design Suite 14.2 and associated tools
MATLAB (if you want to load images over UART)
```

### Installing

1. Open ISE
2. Navigate to the Enlightened Main Project folder
3. Open the project (Enlightened.xise)

## Running the tests

There exists one test file that can be run in ISim to verify the functionality of the SPI module. The test resides inside Test_SPI.v

## Deployment

To deploy on a Zedboard Zynq-7000 FPGA:

1. Select Tools > iMPACT in the ISE window. 
2. If ISE asks if you want to regenerate files, select the No option.
3. When iMPACT opens, double-click on Boundary Scan in the left panel.
4. Right click in the blank space on the right and select Initialize Chain. You will see two processors.
5. Assign the configuration (.bit) file for the xc7z020 by right clicking it and selecting Assign a New Configuration File.
6. Select from within the project folder, 'final_loud_threshold.bit'.
7. Right click the xc7z020 and select Program. The program will be loaded onto the FPGA.

## Project Code (Verilog and VHDL)

### GitHub Folders

* **Enlightened Main Project** - *Completed system code*
* **Experimental** - *Includes implemented UART code for Zedboard and partial FFT code (colored spectrum)*
* **LED_Matrix_FPGA_MATLAB** - *MATLAB code for use with UART code*
* **LED_Matrix_FPGA_Nexys3** - *Test code on Nexys3*
* **Microphone code (Not used)** - *Original microphone code*
* **Zedboard Reference** - *Reference Files*

### Module Descriptions

* ADAU1761Top.v - Main module, connects in multiple clock core for control of individual components
* animation.v - Modified module for displaying music animation
* Claps.v - Clap detection
* ClapTest.v
* Clock48MHZ_exdes.v
* Clock48MHZ_tb.v
* Clock48MHZ.v
* HighPassFilter.v - High Pass Filter
* LowPassFilter.v - Low Pass Filter
* Microphone.v
* MicrophoneTop.v
* OLED.v - OLED display control
* OLEDText.v - Font for being displayed on the OLED display
* ProcessingUnit.v
* SPI.v - SPI mdoule for use with OLED
* Test_OLED.v
* Test_SPI.v
* Testing.v
* bram.vhd - Image storage when data sent from UART
* display_control.vhd - Main control for 32 x 32 LED matrix

### Built With

* [The Signal Path](http://thesignalpath.com/blogs/2015/09/01/tutorial-on-the-design-implementation-of-an-fpga-rgb-led-matrix-driver/) - Driver for 32x32 LED Matrix by Adafruit
* [Zedboard Audio](http://hamsterworks.co.nz/mediawiki/index.php/Zedboard_Audio) - Audio Driver for Zedboard

## Authors

* **Peter Goulakos** - *Microphone (ADC), OLED, SPI, High-pass filter, Low-pass filter* - [peteg944](https://github.com/peteg944)
* **Zack Webster** - *UART (Matlab) with matrix, matrix display driver, project integration* - [mzw23](https://github.com/mzw23)
* **Luzhen Huang** - *Audio Codec, FFT, Frequency Spectrum Display* - [onespark123](https://github.com/onespark123)
* **Runal Nair** - *FFT, Beat Detection Algorithm* - [RunalNair](https://github.com/RunalNair)
* **Christine Duong** - *Matrix display driver adaptation, animation, home mode, systolic array, integration of system*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
