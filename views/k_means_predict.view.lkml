view: k_means_predict {
  label: "[7] BQML: Predictions"

  sql_table_name: ML.PREDICT(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_model_{{ _explore._name }},
                      TABLE @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_input_data_{{ _explore._name }}
                    )
  ;;

  dimension: item_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: centroid_id {
    label: "Nearest Centroid"
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  dimension: nearest_centroids_distance {
    hidden: yes
    type: string
    sql: ${TABLE}.NEAREST_CENTROIDS_DISTANCE ;;
  }

  measure: item_count {
    label: "Count of Observations"
    type: count
    description: "Number of Observations"
  }

  measure: item_count_percent_of_total {
    label: "Percent of Total Observations"
    type: percent_of_total
    description: "Percent of Total Observations in Data Set"
    sql: ${item_count} ;;
  }

  measure: total_item_count {
    type: number
    label: "Total Observations in Data Set"
    description: "Total Number of Observations in Data Set"
    sql: (select count(item_id) from ${k_means_predict.SQL_TABLE_NAME}) ;;
  }

}

view: nearest_centroids_distance {
  label: "[7] BQML: Predictions"

  dimension: item_centroid_id {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${k_means_predict.item_id}, ${centroid_id}) ;;
  }

  dimension: centroid_id {
    group_label: "Centroid Distances"
    label: "Centroid"
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  dimension: distance {
    group_label: "Centroid Distances"
    type: number
    sql: ${TABLE}.DISTANCE ;;
  }
}