"""
author @ gennaro calendo
This is a txt file based parser for output files from
ImageProPlus software
"""
import sys
import pandas as pd


def parse_densitometry(file_name):
    """This function will parse densitometry values from the txt file input
    given by argv and return a DataFrame object."""
    filenames = []
    sums = []
    maxs = []
    ranges = []
    means = []
    stdev = []
    samples = []
    mins = []
    animal_id = []
    location = []
    img_num = []
    obj_num = []    # [min, max, min, max, ...]

    with open(file_name, 'r') as f:
        lines = f.readlines()
        for line in lines:
            try:
                line = line.strip()
                if 'Densitometry' in line:
                    line = line.replace("> Densitometry", "")
                    filenames.append((line[:-4]))
                elif 'Sum' in line:
                    sums.append(float(line[8:]))
                elif 'Max' in line:
                    maxs.append(float(line[8:]))
                elif 'Range' in line:
                    ranges.append(float(line[8:]))
                elif 'Mean' in line:
                    means.append(float(line[8:]))
                elif 'Std.Dev' in line:
                    stdev.append(float(line[8:]))
                elif 'Samples' in line:
                    samples.append(float(line[8:]))
                elif 'Min' in line:
                    mins.append(float(line[8:]))
                elif '(Obj.#)' in line:
                    obj_num.append(int(line[8:]))
            except:
                pass

    # separate information in filenames
    for files in filenames:
        try:
            animal_code = str(files.split('-')[0])
            animal_code = animal_code.replace(" ", "")
            animal_id.append(animal_code)
            location.append(files.split('-')[1])
            img_num.append(int(files.split('-')[2]))
        except:
            pass
    
    # split obj_num list into min and max lists at every other index    
    min_obj = obj_num[::2]
    max_obj = obj_num[1::2]
        
    # create DataFrame by zipping together lists
    df = pd.DataFrame(list(zip(animal_id,
                               location,
                               img_num,
                               maxs,
                               mins,
                               ranges,
                               means,
                               stdev,
                               samples,
                               min_obj,
                               max_obj, 
                               sums)),
                        columns=['animal_id',
                                 'location',
                                 'img_num',
                                 'max',
                                 'min',
                                 'range',
                                 'mean',
                                 'stdev',
                                 'samples',
                                 'min_obj_num',
                                 'max_obj_num',
                                 'Vg'])
    
    # make new columns for calculated values
    df['Vp'] = 1 - df['Vg']
    df['Exp_Index'] = df['Vg'] / df['Vp'] * 100 
    
    return df

def parse_alveolar(file_name):
        """This function will parse alveolar values from the txt file input
        given by argv and return a DataFrame object"""
        filenames = []
        animal_id = []
        location = []
        img_num = []
        min_area = []
        min_dia = []
        min_per = []
        max_area = []
        max_dia = []
        max_per = []
        range_area = []
        range_dia = []
        range_per = []
        mean_area = []
        mean_dia = []
        mean_per = []
        stdev_area = []
        stdev_dia = []
        stdev_per = []
        sum_area = []
        sum_dia = []
        sum_per = []
        sample_area = []
        sample_dia = []
        sample_per = []
        obj_num_area = []  # [min, max, min, max, ...]
        obj_num_dia = []   # [min, max, min, max, ...]
        obj_num_per = []   # [min, max, min, max, ...]

        # parse the alveolar parameters text file
        with open(file_name, 'r') as f:
            lines = f.readlines()
            for line in lines:
                line = line.strip()
                try:
                    if 'Alveolar' in line:
                        line = line.replace("> Alveolar Parameters", "")
                        filenames.append((line[:-4]))
                    elif "Min" in line:
                        min_area.append(float(line.split()[1]))
                        min_dia.append(float(line.split()[2]))
                        min_per.append(float(line.split()[3]))
                    elif 'Max' in line:
                        max_area.append(float(line.split()[1]))
                        max_dia.append(float(line.split()[2]))
                        max_per.append(float(line.split()[3]))
                    elif 'Range' in line:
                        range_area.append(float(line.split()[1]))
                        range_dia.append(float(line.split()[2]))
                        range_per.append(float(line.split()[3]))
                    elif 'Mean' in line:
                        mean_area.append(float(line.split()[1]))
                        mean_dia.append(float(line.split()[2]))
                        mean_per.append(float(line.split()[3]))
                    elif 'Std.Dev' in line:
                        stdev_area.append(float(line.split()[1]))
                        stdev_dia.append(float(line.split()[2]))
                        stdev_per.append(float(line.split()[3]))
                    elif 'Sum' in line:
                        sum_area.append(float(line.split()[1]))
                        sum_dia.append(float(line.split()[2]))
                        sum_per.append(float(line.split()[3]))
                    elif 'Samples' in line:
                        sample_area.append(float(line.split()[1]))
                        sample_dia.append(float(line.split()[2]))
                        sample_per.append(float(line.split()[3]))
                    elif '(Obj.#)' in line:
                        obj_num_area.append(int(line.split()[1]))
                        obj_num_dia.append(int(line.split()[2]))
                        obj_num_per.append(int(line.split()[3]))
                except:
                    continue

        # separate information in filenames list
        for files in filenames:
            try:
                animal_code = str(files.split('-')[0])
                animal_code = animal_code.replace(" ", "")
                animal_id.append(animal_code)
                location.append(files.split('-')[1])
                img_num.append(int(files.split('-')[2]))
            except:
                pass
        
        # set up lists for obj number counts
        min_obj_num_a = obj_num_area[::2]
        min_obj_num_d = obj_num_dia[::2]
        min_obj_num_p = obj_num_per[::2]
        
        max_obj_num_a = obj_num_area[1::2]
        max_obj_num_d = obj_num_dia[1::2]
        max_obj_num_p = obj_num_per[1::2]

        # create DataFrame by zipping together lists
        df = pd.DataFrame(list(zip(animal_id,
                                   location,
                                   img_num,
                                   min_area,
                                   min_dia,
                                   min_per,
                                   max_area,
                                   max_dia,
                                   max_per,
                                   range_area,
                                   range_dia,
                                   range_per,
                                   mean_area,
                                   mean_dia,
                                   mean_per,
                                   stdev_area,
                                   stdev_dia,
                                   stdev_per,
                                   sum_area,
                                   sum_dia,
                                   sum_per,
                                   sample_area,
                                   sample_dia,
                                   sample_per,
                                   min_obj_num_a,
                                   min_obj_num_d,
                                   min_obj_num_p,
                                   max_obj_num_a,
                                   max_obj_num_d,
                                   max_obj_num_p)),
                          columns=['animal_id',
                                   'location',
                                   'img_num',
                                   'min area',
                                   'min diameter',
                                   'min perimeter',
                                   'max area',
                                   'max diameter',
                                   'max perimeter',
                                   'range area',
                                   'range diameter',
                                   'range perimeter',
                                   'mean area',
                                   'mean diameter',
                                   'mean perimeter',
                                   'stdev area',
                                   'stdev diameter',
                                   'stdev perimeter',
                                   'Vg area',
                                   'Vg diameter',
                                   'Vg perimeter',
                                   'sample area',
                                   'sample diameter',
                                   'sample perimeter',
                                   'min obj # - area',
                                   'min obj # - dia',
                                   'min obj # - per',
                                   'max obj # - area',
                                   'max obj # - dia',
                                   'max obj # - per'])

        return df

def main():
    densitometry_file = sys.argv[1]
    alveolar_file = sys.argv[2]
#    densitometry_file = r'D:\Desktop\densitometry.txt'  # for testing
#    alveolar_file = r'D:\Desktop\alveolar.txt'          # for testing
    
    # set up dataframes
    df1 = parse_densitometry(densitometry_file)
    df2 = parse_alveolar(alveolar_file)
    df3 = df1.groupby(['animal_id', 'location']).mean().reset_index()
    df4 = df2.groupby(['animal_id', 'location']).mean().reset_index()
    
    # sort sheets by animal_id and then by location and img_num
    df1.sort_values(['animal_id', 'location', 'img_num'], ascending=[True, False, True])
    df2.sort_values(['animal_id', 'location', 'img_num'], ascending=[True, False, True]) 
    df3.sort_values(['animal_id', 'location', 'img_num'], ascending=[True, False, True])
    df4.sort_values(['animal_id', 'location', 'img_num'], ascending=[True, False, True])

    # write each datafreame to excel file
    writer = pd.ExcelWriter(r'D:\Desktop\lung_data.xlsx')
    df1.to_excel(writer, sheet_name="Densitometry raw", index=False)
    df2.to_excel(writer, sheet_name="Alveolar raw", index=False)
    df3.to_excel(writer, sheet_name="Densitometry Avgs.", index=False)
    df4.to_excel(writer, sheet_name="Alveolar Avgs.", index=False)
    writer.save()

if __name__ == '__main__':
    main()
