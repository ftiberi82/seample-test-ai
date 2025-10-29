package it.gov.mgs.account_service.data.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Rappresenta una tipologia (livello) organizzativa (tabella ORGANIZATION_TYPE).
 * Ogni record definisce un livello gerarchico utilizzato per classificare le
 * organizzazioni (es. Ministero, Direzione, Ufficio ...).
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ORGANIZATION_TYPE")
public class OrganizationType extends AuditedEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", nullable = false, columnDefinition = "uniqueidentifier")
    private UUID id;

    @Column(name = "order", nullable = false, unique = true)
    private Integer order;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "description", length = 1024)
    private String description;

}
